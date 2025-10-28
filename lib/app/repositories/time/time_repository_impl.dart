import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/time_model.dart';

import './time_repository.dart';

class TimeRepositoryImpl implements TimeRepository {
  final RestClient _restClient;

  TimeRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<List<TimeModel>> getTime() async {
    final result = await _restClient.get('/horarios');

    if (result.hasError) {
      log('Erro ao configurar horários', error: result.statusText, stackTrace: StackTrace.current);
      throw RestClientException(message: 'Erro ao configurar horários');
    }

    final List data = (result.body as List);

    log('RESULT BODY: $data');

    final timeModel = data.map((e) => TimeModel.fromMap(e)).toList();

    return timeModel;
  }
}
