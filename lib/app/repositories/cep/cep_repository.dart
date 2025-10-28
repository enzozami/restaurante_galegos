abstract interface class CepRepository {
  Future<Map<String, dynamic>> getCep(int cep);
}
