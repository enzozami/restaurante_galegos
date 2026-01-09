import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class DrawerGalegosController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;

  final Rxn<MessageModel> _message = Rxn<MessageModel>();
  RxString nome = ''.obs;
  RxString email = ''.obs;
  RxBool isAdmin = false.obs;

  final isPressed = false.obs;

  DrawerGalegosController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onReady() {
    super.onReady();
    try {
      nome = _authServices.nome;
      email = _authServices.email;
      isAdmin.value = _authServices.isAdmin();
    } catch (e) {
      log(e.toString());
      _message.value = MessageModel(
        title: 'Erro',
        message: 'Erro ao puxar dados do usuário',
        type: MessageType.error,
      );
    }
  }

  void logout() => _authServices.logout();
}
