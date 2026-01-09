import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';

import './auth_services.dart';

class AuthServicesImpl extends GetxService implements AuthServices {
  final AuthRepository _authRepository;
  final _isLogged = RxnBool();
  final _isAdmin = RxnBool();
  final _getStorage = GetStorage();
  final RxString _userEmail = ''.obs;
  final _name = ''.obs;

  @override
  RxString get nome => _name;

  @override
  RxString get email => _userEmail;

  static const diasSemana = {
    1: "Segunda-feira",
    2: "Terça-feira",
    3: "Quarta-feira",
    4: "Quinta-feira",
    5: "Sexta-feira",
    6: "Sábado",
    7: "Domingo",
  };

  AuthServicesImpl({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<void> onReady() async {
    super.onReady();
    await getUser();
  }

  @override
  Future<UserModel> login({required String email, required String password}) =>
      _authRepository.login(email: email, password: password);

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) => _authRepository.register(name: name, email: email, password: password, phone: phone);

  Future<bool> openOrClosedRestaurant() async {
    if (kDebugMode) return true;
    final now = DateTime.now();

    final snapshot = await FirebaseFirestore.instance.collection('horario_funcionamento').get();
    if (snapshot.docs.isEmpty) return false;
    final dataApi = snapshot.docs.first.data(); // PEGANDO DADOS QUE VEM DA API SE NAO TIVER VAZIO

    final hoje = diasSemana[now.weekday];
    final List<String> diasFuncionamentoApi =
        (dataApi['days'] as List<dynamic>?)?.map((day) => day.toString()).toList() ??
        <String>[]; // pega os dias que está registrado na api

    if (!diasFuncionamentoApi.contains(hoje)) return false;

    final horasCelular =
        (now.hour * 100) +
        now.minute; // horario do celular - transformando em numero para comparar exemplo 09:00 = 900

    final horaInicialFuncionamento = formatarHorarioApi(dataApi['inicio']);
    final horaFimFuncionamento = formatarHorarioApi(dataApi['fim']);

    return horasCelular >= horaInicialFuncionamento && horasCelular <= horaFimFuncionamento;
  }

  int formatarHorarioApi(String? hhmm) {
    if (hhmm == null) return 0;
    return int.parse(hhmm.replaceAll(':', ''));
  }

  @override
  Future<AuthServices> init() async {
    _name.value = _getStorage.read(Constants.USER_NAME) ?? '';
    _userEmail.value = _getStorage.read(Constants.USER_KEY) ?? '';

    if (await openOrClosedRestaurant()) {
      _getStorage.listenKey(Constants.USER_KEY, (value) {
        _isLogged(value != null);
      });
      _getStorage.listenKey(Constants.ADMIN_KEY, (value) {
        _isAdmin((value is bool) ? value : false);
      });
      _getStorage.listenKey(Constants.USER_NAME, (value) {
        _name.value = value ?? '';
      });

      ever(_isLogged, (isLogged) {
        if (isLogged == true) {
          Get.offAllNamed('/home');
        }
      });

      _isLogged(getUserId() != null);
      return this;
    } else {
      final snapshot = await FirebaseFirestore.instance.collection('horario_funcionamento').get();
      final horariosApi = snapshot.docs.first.data();

      Get.snackbar(
        'Fora do horário de funcionamento',
        'Nós funcionamos das ${horariosApi['inicio']}h às ${horariosApi['fim']}h!',
        backgroundColor: AppColors.primary,
        colorText: Colors.black,
        margin: EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
        snackPosition: .TOP,
      );
      return this;
    }
  }

  @override
  void logout() {
    _getStorage.write(Constants.USER_KEY, null);
    _getStorage.write(Constants.ADMIN_KEY, null);
    _getStorage.write(Constants.USER_NAME, null);
    Get.offAllNamed('/');
  }

  @override
  String? getUserId() => _getStorage.read(Constants.USER_KEY);

  @override
  bool isAdmin() => _getStorage.read(Constants.ADMIN_KEY) ?? false;

  @override
  Future<void> resetPassword({required String email}) =>
      _authRepository.resetPassword(email: email);

  @override
  Future<void> updateData(String? newName, String? newEmail, PhoneAuthCredential? newPhone) =>
      _authRepository.updateData(newName, newEmail, newPhone);

  @override
  Future<UserModel> getUser() async {
    final user = await _authRepository.getUser();
    _name.value = user.nome;
    _userEmail.value = user.email;

    await _getStorage.write(Constants.USER_NAME, user.nome);
    return user;
  }

  @override
  Future<void> reauthenticate(String password) => _authRepository.reauthenticate(password);
}
