import 'package:restaurante_galegos/app/models/user_model.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';

import './auth_services.dart';

class AuthServicesImpl implements AuthServices {
  final AuthRepository _authRepository;

  AuthServicesImpl({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<UserModel> login({required bool isCpf, required String value, required String password}) =>
      _authRepository.login(isCpf: isCpf, value: value, password: password);
}
