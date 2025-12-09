import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class RegisterController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameEC = TextEditingController();
  final TextEditingController passwordEC = TextEditingController();
  final TextEditingController emailEC = TextEditingController();

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final RxBool _viewConfirmPassword = false.obs;

  bool get viewConfirmPassword => _viewConfirmPassword.value;

  RegisterController({required AuthServices authServices}) : _authServices = authServices;

  @override
  Future<void> onInit() async {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onClose() {
    nameEC.dispose();
    passwordEC.dispose();
    emailEC.dispose();
    super.onClose();
  }

  bool _validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void changePasswordVisibility() {
    _viewConfirmPassword.value = !_viewConfirmPassword.value;
  }

  Future<void> register() async {
    try {
      _loading.value = true;
      if (!_validateForm()) return;

      await _authServices.register(
        name: nameEC.text,
        email: emailEC.text,
        password: passwordEC.text,
      );
    } on AuthException catch (e, s) {
      log(e.toString());
      log(s.toString());
      _loading.value = false;
      500.milliseconds.delay();
      _message(
        MessageModel(title: 'Erro', message: e.message, type: MessageType.error),
      );
    } finally {
      _loading.value = false;
    }
  }
}
