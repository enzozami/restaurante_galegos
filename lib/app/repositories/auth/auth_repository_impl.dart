import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      final isAdmin = data['isAdmin'] ?? false;

      return UserModel(
        id: firebaseUser.uid.hashCode,
        name: data['nome'] ?? '',
        email: data['email'] ?? '',
        cpfOrCnpj: data['cpfOrCnpj'],
        password: password,
        isAdmin: isAdmin,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Erro ao fazer login');
    }
  }

  @override
  Future<UserModel> register({
    required bool isCpf,
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
        'createdAt': FieldValue.serverTimestamp(),
      });

      return login(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw AuthException(message: 'A senha é fraca demais.');
        case 'password-does-not-meet-requirements':
          throw AuthException(message: 'A senha não atende aos requisitos definidos.');
        case 'requires-uppercase':
          throw AuthException(message: 'A senha deve conter pelo menos uma letra maiúscula.');
        case 'requires-lowercase':
          throw AuthException(message: 'A senha deve conter pelo menos uma letra minúscula.');
      }
      throw AuthException(message: e.message ?? 'Erro ao fazer cadastro');
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
}

class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
}
