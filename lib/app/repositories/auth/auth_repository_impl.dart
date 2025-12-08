import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';

import './auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _firebase = FirebaseAuth.instance;

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final result = await _firebase.signInWithEmailAndPassword(email: email, password: password);

      final firebaseUser = result.user;

      if (firebaseUser == null) {
        throw AuthException(message: 'Usuário inválido');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException(message: 'Dados do usuário não encontrados');
      }

      final data = userDoc.data()!;
      final bool isAdmin = data['isAdmin'] ?? false;

      log('Usuário é administrador: $isAdmin - (AUTHREPOSITORY)');

      final storage = GetStorage();
      storage.write(Constants.USER_KEY, firebaseUser.uid);
      storage.write(Constants.ADMIN_KEY, isAdmin);
      storage.write(Constants.USER_NAME, firebaseUser.displayName);

      return UserModel(
        uid: firebaseUser.uid,
        name: data['nome'] ?? '',
        email: data['email'] ?? '',
        password: password,
        isAdmin: isAdmin,
      );
    } on FirebaseAuthException catch (e) {
      late String mensagem;

      switch (e.code) {
        case 'invalid-email':
          mensagem = 'E-mail inválido.';
          break;
        case 'user-disabled':
          mensagem = 'Esse usuário foi desativado.';
          break;
        case 'user-not-found':
          mensagem = 'Não existe usuário com esse e-mail.';
          break;
        case 'wrong-password':
          mensagem = 'Senha incorreta.';
          break;
        case 'too-many-request':
          mensagem = 'Muitas tentativas. Tente novamente mais tarde.';
          break;
        case 'network-request-failed':
          mensagem = 'Falha de conexão. Verifique sua internet';
          break;
        case 'invalid-credential':
          mensagem = 'E-mail ou senha inválidos.';
          break;
        default:
          mensagem = 'Erro inesperado. Tente novamente.';
          break;
      }
      throw AuthException(message: mensagem);
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = result.user;

      if (firebaseUser == null) {
        throw AuthException(message: 'Erro ao criar usuário');
      }

      await firebaseUser.updateDisplayName(name);

      await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
        'nome': name,
        'email': email,
        'isAdmin': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final storage = GetStorage();
      storage.write(Constants.USER_KEY, result.user?.uid);
      storage.write(Constants.ADMIN_KEY, false);
      storage.write(Constants.USER_NAME, result.user?.displayName);
      return login(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      late String mensagem;

      switch (e.code) {
        case 'weak-password':
          mensagem = 'A senha é fraca demais.';
          break;
        case 'password-does-not-meet-requirements':
          mensagem = 'A senha não atende aos requisitos definidos.';
          break;
        case 'requires-uppercase':
          mensagem = 'A senha deve conter pelo menos uma letra maiúscula.';
          break;
        case 'requires-lowercase':
          mensagem = 'A senha deve conter pelo menos uma letra minúscula.';
          break;
        case 'invalid-email':
          mensagem = 'E-mail inválido.';
          break;
        case 'email-already-in-use':
          mensagem = 'Esse e-mail já existe.';
          break;
        default:
          mensagem = 'Erro ao cadastrar usuário';
          break;
      }

      throw AuthException(message: mensagem);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebase.sendPasswordResetEmail(email: email);
    } catch (e, s) {
      log('Erro ao resetar senha', error: e, stackTrace: s);
      throw AuthException(message: 'Erro ao resetar senha');
    }
  }

  @override
  Future<void> updateUserName({required String newName}) async {
    if (_firebase.currentUser != null) {
      await _firebase.currentUser?.updateDisplayName(newName);
      FirebaseFirestore.instance
          .collection('users')
          .doc(_firebase.currentUser?.uid.toString())
          .update(
            {'nome': newName},
          );
      final storage = GetStorage();
      storage.write(Constants.USER_NAME, newName);
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
}
