import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
import 'package:restaurante_galegos/app/models/cep_model.dart';

import './cep_repository.dart';

class CepRepositoryImpl implements CepRepository {
  final ViaCepService _viaCepService;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CepRepositoryImpl({required ViaCepService viaCepService}) : _viaCepService = viaCepService;

  @override
  Future<Map<String, dynamic>> getCep(String cep) async {
    final sanitizedCep = cep.toString().replaceAll('-', '');
    final result = await _viaCepService.get('$sanitizedCep/json/');

    if (result.hasError) {
      log(
        'Erro ao buscar CEP: ${result.statusText}',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      throw ViaCepException(message: 'Erro ao buscar CEP');
    }

    log('${result.body}');

    return result.body;
  }

  @override
  Future<List<CepModel>> getCepModel() async {
    final snapshot = await firestore.collection('ceps').get();

    return snapshot.docs.map((doc) => CepModel.fromMap({...doc.data(), 'id': doc.id})).toList();
  }
}
