import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;

  final formKeyLogin = GlobalKey<FormState>();
  final formKeyReset = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  final _message = Rxn<MessageModel>();
  final _loading = false.obs;
  final RxBool _viewPassword = true.obs;

  bool get viewPassword => _viewPassword.value;

  LoginController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onClose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.onClose();
  }

  void changePasswordVisibility() {
    _viewPassword.value = !_viewPassword.value;
  }

  bool _validateLogin() {
    return formKeyLogin.currentState?.validate() ?? false;
  }

  Future<void> senhaNova() async {
    try {
      final teste = formKeyReset.currentState?.validate() ?? false;
      if (!teste) return;
      await _authServices.resetPassword(email: emailEC.text);
      log('Mensagem enviada');
      Get.back();
    } catch (e) {
      log('Erro ao resetar senha', error: e);
    }
  }

  Future<void> login() async {
    try {
      _loading.value = true;
      if (!_validateLogin()) return;

      await _authServices.login(email: emailEC.text, password: passwordEC.text);
    } on AuthException catch (e, s) {
      _loading.value = false;
      await 500.milliseconds.delay();
      log('Falha no login', error: e, stackTrace: s);
      _message.value = MessageModel(
        title: 'Erro',
        message: e.message,
        type: MessageType.error,
      );
    } finally {
      _loading.value = false;
    }
  }
}
