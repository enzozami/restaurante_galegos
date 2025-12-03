import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class RegisterController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final _isChecked = false.obs;

  bool get isChecked => _isChecked.value;

  final isSelectedConfirmaSenha = true.obs;

  RegisterController({required AuthServices authServices}) : _authServices = authServices;

  @override
  Future<void> onInit() async {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void seeConfirmPassword() {
    isSelectedConfirmaSenha.value = !isSelectedConfirmaSenha.value;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _loading.value = true;
      await _authServices.register(
        name: name,
        email: email,
        password: password,
      );
    } on AuthException catch (e, s) {
      log(e.toString());
      log(s.toString());
      _loading.value = false;
      _message(
        MessageModel(title: 'Erro', message: e.message, type: MessageType.error),
      );
    } finally {
      _loading.value = false;
    }
  }
}
