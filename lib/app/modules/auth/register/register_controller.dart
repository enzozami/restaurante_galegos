import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/enums/galegos_enum.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class RegisterController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final type = GalegosEnum.cpf.obs;
  final typeMask = MaskCpf().obs;

  RegisterController({
    required AuthServices authServices,
  }) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  Future<void> register({
    required String name,
    required password,
  }) async {
    log('CONTROLLERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');
    try {
      _loading.toggle();
      await _authServices.register(name, type.value, password);
      _loading.toggle();
      Get.offAllNamed('/auth/login');
    } catch (e, s) {
      _loading.toggle();
      log(e.toString());
      log(s.toString());
      MessageModel(title: 'Erro', message: 'Erro ao cadastrar usuário', type: MessageType.error);
    } finally {
      _loading(false);
    }
  }
}
