import 'package:get/get_connect/connect.dart';

class RestClient extends GetConnect {
  // final _baseUrl = 'http://10.24.24.247:8080'; // EMPRESA
  // final _baseUrl = 'http://192.168.15.7:8080'; // pc de casa
  // final _baseUrl = 'http://192.168.100.49:8080'; // restaurante
  final _baseUrl = 'http://192.168.15.9:8080';

  RestClient() {
    httpClient.baseUrl = _baseUrl;
  }
}

class RestClientException implements Exception {
  final int? code;
  final String message;

  RestClientException({
    this.code,
    required this.message,
  });

  @override
  String toString() => 'RestClientException(code : $code, message: $message)';
}
