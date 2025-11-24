import 'package:restaurante_galegos/app/models/user_model.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';

import './auth_services.dart';

class AuthServicesImpl implements AuthServices {
  final AuthRepository _authRepository;

  AuthServicesImpl({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<UserModel> login({required String email, required String password}) =>
      _authRepository.login(email: email, password: password);

  @override
  Future<UserModel> register({
    required bool isCpf,
    required String name,
    required String email,
    required String cpfOrCnpj,
    required String password,
  }) => _authRepository.register(
    isCpf: isCpf,
    name: name,
    cpfOrCnpj: cpfOrCnpj,
    email: email,
    password: password,
  );
}
