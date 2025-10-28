import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';

import './cep_repository.dart';

class CepRepositoryImpl implements CepRepository {
  final ViaCepService _viaCepService;

  CepRepositoryImpl({required ViaCepService viaCepService}) : _viaCepService = viaCepService;

  @override
  Future<Map<String, dynamic>> getCep(int cep) async {
    final result = await _viaCepService.get('$cep/json/');

    if (result.hasError) {
      throw Exception();
    }

    log('${result.body}');

    return result.body;
  }
}
