import 'package:restaurante_galegos/app/repositories/cep/cep_repository.dart';

import './cep_services.dart';

class CepServicesImpl implements CepServices {
  final CepRepository _cepRepository;

  CepServicesImpl({required CepRepository cepRepository}) : _cepRepository = cepRepository;

  @override
  Future<Map<String, dynamic>> getCep(int cep) => _cepRepository.getCep(cep);
}
