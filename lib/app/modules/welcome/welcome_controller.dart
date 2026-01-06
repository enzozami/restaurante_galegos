import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services_impl.dart';

class WelcomeController extends GetxController with LoaderMixin, MessagesMixin {
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void goToLogin() => Get.toNamed('/auth/login');
  Future<void> goToRegister() async {
    _loading.value = true;
    await 500.milliseconds.delay();
    _loading.value = false;
    await 100.milliseconds.delay();
    Get.toNamed('/auth/register');
  }

  Future<void> accessApp() async {
    try {
      _loading.value = true;
      await 1.seconds.delay();
      if (!Get.isRegistered<AuthServicesImpl>()) {
        await Get.putAsync(() async {
          return await AuthServicesImpl(authRepository: Get.find<AuthRepository>()).init();
        });
      }
      _loading.value = false;
      await 100.milliseconds.delay();
      if (Get.currentRoute == '/' && Get.find<AuthServices>().getUserId() == null) {
        goToLogin();
      }
    } catch (e, s) {
      _loading.value = false;
      log(e.toString());
      log(s.toString());
      _message.value = MessageModel(
        title: 'Erro',
        message: 'Erro ao inicializar AuthServices',
        type: MessageType.error,
      );
    } finally {
      _loading.value = false;
    }
  }
}
