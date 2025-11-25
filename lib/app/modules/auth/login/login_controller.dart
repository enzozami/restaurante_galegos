// import 'dart:developer';

import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final typeMask = MaskCpf().obs;
  final isCpf = true.obs;
  final isSelected = true.obs;
  final isChecked = false.obs;

  LoginController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void onSelected(bool value) {
    isChecked.value = value;
    isCpf.value = !value;
  }

  void seePassword() {
    isSelected.value = !isSelected.value;
  }

  Future<void> login({required String value, required String password}) async {
    try {
      _loading(true);
      final userLogger = await _authServices.login(email: value, password: password);
      log('Usuário admin: ${userLogger.isAdmin}');
      final storage = GetStorage();
      storage.write(Constants.ADMIN_KEY, userLogger.isAdmin);
      storage.write(Constants.USER_KEY, userLogger.id);
      storage.write(Constants.USER_NAME, userLogger.name);
      storage.write(Constants.USER_CPFORCNPJ, userLogger.cpfOrCnpj);
    } on AuthException catch (e, s) {
      _loading(false);
      log('Falha no login', error: e, stackTrace: s);
      _message.value = MessageModel(
        title: 'Falha no login',
        message:
            'CPF/CNPJ ou senha incorreta', // pode ser "Senha incorreta" ou outro texto vindo do service
        type: MessageType.error,
      );
    } finally {
      _loading(false);
    }
  }
}
