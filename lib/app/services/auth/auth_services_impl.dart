import 'package:restaurante_galegos/app/core/enums/galegos_enum.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';

import './auth_services.dart';

class AuthServicesImpl implements AuthServices {
  final AuthRepository _authRepository;

  AuthServicesImpl({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<UserModel> login(String user, GalegosEnum type, String password) =>
      _authRepository.login(user, type, password);

  @override
  Future<UserModel> register(String name, GalegosEnum type, String password) =>
      _authRepository.register(name, type, password);
}
