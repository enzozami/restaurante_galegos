import 'dart:developer';

import 'package:restaurante_galegos/app/core/enums/galegos_enum.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';

import './auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RestClient _restClient;

  AuthRepositoryImpl({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<UserModel> login(String user, GalegosEnum type, String password) async {
    final result = await _restClient.post('/users', {
      'user': user,
      'type': GalegosEnum.values,
      'password': password,
    });

    if (result.hasError) {
      if (result.statusCode == 403) {
        log('Usuário ou senha inválidos');
      }
      log('Erro logar');
    }

    return UserModel.fromMap(result.body);
  }

  @override
  Future<UserModel> register(String name, GalegosEnum type, String password) async {
    final result = await _restClient.post('/users', {
      'name': name,
      'type': type,
      'password': password,
    });

    if (result.hasError) {
      log('Erro ao cadastrar usuário');
    }

    return UserModel.fromMap(result.body);
  }
}
