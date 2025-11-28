import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';

import './auth_services.dart';

class AuthServicesImpl extends GetxService implements AuthServices {
  final AuthRepository _authRepository;
  final _isLogged = RxnBool();
  final _isAdmin = RxnBool();
  final _name = RxnString();
  final _cpfOrCnpj = RxnString();
  final _getStorage = GetStorage();

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

  bool canUseApp() {
    if (kDebugMode) return true;
    var timeNow = DateTime.now();

    final inicio = DateTime(timeNow.year, timeNow.month, timeNow.day, 9, 0);
    final fim = DateTime(timeNow.year, timeNow.month, timeNow.day, 14, 50);

    return inicio.isBefore(timeNow) && fim.isAfter(timeNow);
  }

  @override
  Future<AuthServices> init() async {
    if (canUseApp()) {
      _getStorage.listenKey(Constants.USER_KEY, (value) {
        _isLogged(value != null);
      });
      _getStorage.listenKey(Constants.ADMIN_KEY, (value) {
        _isAdmin((value is bool) ? value : false);
      });
      _getStorage.listenKey(Constants.USER_NAME, (value) {
        _name(value ?? '');
      });
      _getStorage.listenKey(Constants.USER_CPFORCNPJ, (value) {
        _cpfOrCnpj(value ?? '');
      });

      ever(_isLogged, (isLogged) {
        if (isLogged == null || !isLogged) {
          Get.offAllNamed('/auth/login');
        } else {
          Get.offAllNamed('/home');
        }
      });

      _isLogged(getUserId() != null);
      return this;
    } else {
      Get.snackbar(
        'Fora do horário de funcionamento',
        'Nós funcionamos das 09:00 às 14:50h!',
        duration: 3.seconds,
        backgroundColor: GalegosUiDefaut.colorScheme.primary,
      );
      return this;
    }
  }

  @override
  void logout() {
    _getStorage.write(Constants.USER_KEY, null);
    _getStorage.write(Constants.ADMIN_KEY, false);
    _getStorage.write(Constants.USER_NAME, null);
    _getStorage.write(Constants.USER_CPFORCNPJ, null);
  }

  @override
  int? getUserId() => _getStorage.read(Constants.USER_KEY);

  @override
  String? getUserName() => _getStorage.read(Constants.USER_NAME);

  @override
  String? getUserCPFORCNPJ() => _getStorage.read(Constants.USER_CPFORCNPJ);

  @override
  bool isAdmin() => _getStorage.read(Constants.ADMIN_KEY) ?? false;

  @override
  Future<void> resetPassword({required String email}) =>
      _authRepository.resetPassword(email: email);
}
