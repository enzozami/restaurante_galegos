import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;

  UserRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<UserModel> getUser({required int id}) async {
    final result = await _restClient.get('/users');

    if (result.hasError) {
      log(
        'Erro ao buscar dados do usuário',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      throw RestClientException(message: 'Erro ao buscar dados do usuário');
    }

    final data = List<Map<String, dynamic>>.from(result.body);

    final user = data.firstWhere((u) => u['id'] == id);

    return UserModel.fromMap(user);
  }

  @override
  Future<UserModel> updateUser(String name, String password, {required int id}) async {
    final result = await _restClient.put('/users/$id', {'name': name, 'password': password});

    if (result.hasError) {
      log('Erro ao atualizar dados', error: result.statusText, stackTrace: StackTrace.current);
      throw RestClientException(message: 'Erro ao atualizar dados');
    }

    return UserModel.fromMap(result.body);
  }
}
