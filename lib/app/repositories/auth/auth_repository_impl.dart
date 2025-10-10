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
    final data = List<Map<String, dynamic>>.from(result.body);

    // log('hkjlmkjmnlmnl$data');

    final user = data.firstWhere((u) => u['value'] == value);
    // log('asdwasd w$user');

    return UserModel.fromMap(user);
  }

  @override
  Future<UserModel> register({
    required bool isCpf,
    required String name,
    required String value,
    required String password,
  }) async {
    final result = await _restClient.post('/users', {
      'isCpf': isCpf,
      'name': name,
      'value': value,
      'password': password,
    });

    if (result.hasError) {
      log('Erro ao realizar cadastro:', error: result.statusText, stackTrace: StackTrace.current);
      throw RestClientException(message: 'Erro ao fazer cadastro');
    }

    return login(isCpf: isCpf, value: value, password: password);
  }
}
