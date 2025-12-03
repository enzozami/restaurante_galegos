import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final isSelected = true.obs;
  final isChecked = false.obs;

  LoginController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void seePassword() {
    isSelected.value = !isSelected.value;
  }

  Future<void> senhaNova({required String email}) async {
    try {
      await _authServices.resetPassword(email: email);
    } catch (e) {
      log('Erro ao resetar senha', error: e);
    }
  }

  Future<void> login({required String value, required String password}) async {
    try {
      _loading.value = true;
      final userLogger = await _authServices.login(email: value, password: password);
      final storage = GetStorage();
      storage.write(Constants.ADMIN_KEY, userLogger.isAdmin);
      storage.write(Constants.USER_KEY, userLogger.id);
      storage.write(Constants.USER_NAME, userLogger.name);
    } on AuthException catch (e, s) {
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
