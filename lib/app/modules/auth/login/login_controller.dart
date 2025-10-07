import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';
import 'package:restaurante_galegos/app/core/enums/galegos_enum.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final typeMask = MaskCpf().obs;

  LoginController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  Future<void> login({
    required bool isCpf,
    required String value,
    required String password,
  }) async {
    try {
      _loading.toggle();
      final userLogged = await _authServices.login(isCpf: isCpf, value: value, password: password);
      final storage = GetStorage();
      storage.write(Constants.USER_KEY, userLogged.id);
      _loading.toggle();
    } catch (e) {
      _loading.toggle();
      MessageModel(title: 'Erro', message: 'Erro ao realizar login', type: MessageType.error);
    } finally {
      _loading(false);
    }
  }
}
