import 'package:restaurante_galegos/app/models/cep_model.dart';

abstract interface class CepServices {
  Future<Map<String, dynamic>> getCep(String cep);
  Future<List<CepModel>> getCepModel();
}
