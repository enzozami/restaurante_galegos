import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/services/user/user_services.dart';

class GalegosDrawerController extends GetxController with LoaderMixin, MessagesMixin {
  final UserServices _userServices;
  final AuthService _authService;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _isSelected = false.obs;
  final _isObscure = true.obs;

  bool get isSelected => _isSelected.value;
  set isSelected(bool value) => _isSelected.value = value;
  bool get isObscure => _isObscure.value;

  final _name = ''.obs;
  String get name => _name.value;
  final _password = ''.obs;
  String get password => _password.value;
  final valueCpfOrCnpj = ''.obs;

  GalegosDrawerController({
    required UserServices userServices,
    required AuthService authService,
  })  : _userServices = userServices,
        _authService = authService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    getUser();
  }

  void isSelect() {
    _isSelected.toggle();
  }

  Future<void> getUser() async {
    final userId = _authService.getUserId();
    if (userId != null) {
      final userData = await _userServices.getUser(id: userId);
      _name.value = userData.name;
      _password.value = userData.password;
      valueCpfOrCnpj.value = userData.value;
    }
  }

  Future<void> updateUser(
    String? name,
    String? password,
  ) async {
    final userId = _authService.getUserId();
    if (userId != null) {
      log(name ?? 'nome nao digitado');
      log(password ?? 'senha nao digitada');
      if (name != null && name != '' && password == '' && password != null) {
        await _userServices.updateUser(name, _password.value, id: userId);
      } else if (name != null && password != null && password != '') {
        await _userServices.updateUser(_name.value, password, id: userId);
      } else if (name != null && name != '' && password != null && password != '') {
        await _userServices.updateUser(name, password, id: userId);
      } else if (name != null && password != null && name == '' && password == '') {
        await _userServices.updateUser(_name.value, _password.value, id: userId);
      }
    }
  }
}
