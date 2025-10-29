import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
import 'package:restaurante_galegos/app/models/cep_model.dart';

import './cep_repository.dart';

class CepRepositoryImpl implements CepRepository {
  final ViaCepService _viaCepService;
  final RestClient _restClient;

  CepRepositoryImpl({required ViaCepService viaCepService, required RestClient restClient})
      : _viaCepService = viaCepService,
        _restClient = restClient;

  @override
  Future<Map<String, dynamic>> getCep(String cep) async {
    final sanitizedCep = cep.toString().replaceAll('-', '');
    final result = await _viaCepService.get('$sanitizedCep/json/');

    if (result.hasError) {
      log('Erro ao buscar CEP: ${result.statusText}',
          error: result.statusText, stackTrace: StackTrace.current);
      throw Exception();
    }

    log('${result.body}');

    return result.body;
  }

  @override
  Future<List<CepModel>> getCepModel() async {
    final result = await _restClient.get('/cep');

    if (result.hasError) {
      log('Erro ao buscar CEP: ${result.statusText}',
          error: result.statusText, stackTrace: StackTrace.current);
      throw RestClientException(message: 'Erro ao buscar CEP');
    }
    final body = result.body;
    final data = (body is Map && body.containsKey('cep')) ? body['cep'] as List : body as List;

    return data.map((e) => CepModel.fromMap(e)).toList();
  }
}
