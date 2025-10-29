import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';

class ViaCepService extends GetConnect {
  final _viaCepBaseUrl = dotenv.env['VIA_CEP_BASE_URL'];

  ViaCepService() {
    httpClient.baseUrl = _viaCepBaseUrl;
  }

  Future<Map<String, dynamic>> buscarCep(String cep) async {
    final result = await get('/$cep/json');

    if (result.statusCode == 200) {
      return result.body;
    } else {
      throw Exception('Erro ao buscar CEP');
    }
  }
}
