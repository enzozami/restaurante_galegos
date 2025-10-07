import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class RegisterController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final typeMask = MaskCpf().obs;
  final _isCpf = true.obs;
  final _isChecked = false.obs;

  bool get isCpf => _isCpf.value;
  bool get isChecked => _isChecked.value;

  RegisterController({
    required AuthServices authServices,
  }) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void onSelected(bool value) {
    _isChecked.value = value;
  }

  Future<void> register({
    required String name,
    required String value,
    required String password,
  }) async {
    log('CONTROLLERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');
    try {
      _loading.toggle();
      final userLogged = await _authServices.register(
        isCpf: isCpf,
        name: name,
        value: value,
        password: password,
      );
      _loading.toggle();
      final storage = GetStorage();
      storage.write(Constants.USER_KEY, userLogged.id);
      Get.offAllNamed('/auth/login');
    } catch (e, s) {
      _loading.toggle();
      log(e.toString());
      log(s.toString());
      _message(MessageModel(
        title: 'Erro',
        message: 'Erro ao cadastrar usuário',
        type: MessageType.error,
      ));
    } finally {
      _loading(false);
    }
  }
}
