import 'package:restaurante_galegos/app/models/user_model.dart';

abstract interface class AuthServices {
  Future<UserModel> login({
    required bool isCpf,
    required String value,
    required String password,
  });
}
