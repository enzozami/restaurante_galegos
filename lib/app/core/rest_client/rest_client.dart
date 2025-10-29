import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect/connect.dart';

class RestClient extends GetConnect {
  final _baseUrl = dotenv.env['CURRENT_BASE_URL'];

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
