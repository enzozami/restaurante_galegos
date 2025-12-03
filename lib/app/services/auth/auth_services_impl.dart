import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _getStorage = GetStorage();

  AuthServicesImpl({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<UserModel> login({required String email, required String password}) =>
      _authRepository.login(email: email, password: password);

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) => _authRepository.register(name: name, email: email, password: password);

  Future<bool> canUseApp() async {
    if (kDebugMode) return true;
    var timeNow = DateTime.now();

    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore.collection('horario_funcionamento').get();
    final dateApi = snapshot.docs.first.data();

    const diasSemana = {
      1: "Segunda-feira",
      2: "Terça-feira",
      3: "Quarta-feira",
      4: "Quinta-feira",
      5: "Sexta-feira",
      6: "Sábado",
      7: "Domingo",
    };
    final diaHoje = diasSemana[timeNow.weekday];
    final List<String> diasFuncionamento =
        (dateApi['days'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    if (!diasFuncionamento.contains(diaHoje)) {
      log('Fechado, hoje ($diaHoje) não funcionou');
      return false;
    }

    if (dateApi['inicio'] == null || dateApi['fim'] == null) {
      log('Fechado, horário de início ou fim ausente.');
      return false;
    }

    DateTime montarHorario(DateTime base, String hhmm) {
      final partes = hhmm.split(':');
      final hora = int.parse(partes[0]);
      final minuto = int.parse(partes[1]);
      return DateTime(base.year, base.month, base.day, hora, minuto);
    }

    final inicio = montarHorario(timeNow, dateApi['inicio']);
    final fim = montarHorario(timeNow, dateApi['fim']);

    final aberto = timeNow.isAfter(inicio) && timeNow.isBefore(fim);

    return aberto;
  }

  @override
  Future<AuthServices> init() async {
    if (await canUseApp()) {
      _getStorage.listenKey(Constants.USER_KEY, (value) {
        _isLogged(value != null);
      });
      _getStorage.listenKey(Constants.ADMIN_KEY, (value) {
        _isAdmin((value is bool) ? value : false);
      });
      _getStorage.listenKey(Constants.USER_NAME, (value) {
        _name(value ?? '');
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
  }

  @override
  int? getUserId() => _getStorage.read(Constants.USER_KEY);

  @override
  String? getUserName() => _getStorage.read(Constants.USER_NAME);

  @override
  bool isAdmin() => _getStorage.read(Constants.ADMIN_KEY) ?? false;

  @override
  Future<void> resetPassword({required String email}) =>
      _authRepository.resetPassword(email: email);

  @override
  Future<void> updateUserName({required String newName}) =>
      _authRepository.updateUserName(newName: newName);
}
