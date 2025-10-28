import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/about_us_model.dart';

import './about_us_repository.dart';

class AboutUsRepositoryImpl implements AboutUsRepository {
  final RestClient _restClient;

  AboutUsRepositoryImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<AboutUsModel> getAboutUs() async {
    final result = await _restClient.get('/sobre_nos');

    if (result.hasError) {
      log('Erro ao buscar o "sobre nós"', error: result.statusText, stackTrace: StackTrace.current);
      throw RestClientException(message: 'Eror ao buscar o "sobre nós"');
    }

    final List data = (result.body as List);

    final aboutUsList = data.map((d) => AboutUsModel.fromMap(d)).toList();

    return aboutUsList.first;
  }
}
