import 'package:get/get_connect/connect.dart';

class RestClient extends GetConnect {
  final _baseUrl = 'http://10.24.24.247:8080';

  RestClient() {
    httpClient.baseUrl = _baseUrl;
  }
}

// Exception RestClientException
