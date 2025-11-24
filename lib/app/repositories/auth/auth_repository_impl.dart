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

      return UserModel(
        id: firebaseUser.uid.hashCode,
        name: firebaseUser.displayName ?? '',
        email: email,
        password: password,
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
    required String cpfOrCnpj,
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
        'cpfOrCnpj': cpfOrCnpj,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return login(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Erro ao fazer cadastro');
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
}
