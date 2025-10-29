import 'package:restaurante_galegos/app/models/cep_model.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository.dart';

import './cep_services.dart';

class CepServicesImpl implements CepServices {
  final CepRepository _cepRepository;

  CepServicesImpl({required CepRepository cepRepository}) : _cepRepository = cepRepository;

  @override
  Future<Map<String, dynamic>> getCep(String cep) => _cepRepository.getCep(cep);

  @override
  Future<List<CepModel>> getCepModel() => _cepRepository.getCepModel();
}
