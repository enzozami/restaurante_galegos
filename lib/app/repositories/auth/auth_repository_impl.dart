import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';

import './auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RestClient _restClient;

  AuthRepositoryImpl({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<UserModel> login({
    required bool isCpf,
    required String value,
    required String password,
  }) async {
    final result = await _restClient.get('/users');

    if (result.hasError) {
      log('Erro ao realizar login:', error: result.statusText, stackTrace: StackTrace.current);
      throw RestClientException(message: 'Erro ao fazer login');
    }

    return UserModel.fromMap(result.body);
  }
}
