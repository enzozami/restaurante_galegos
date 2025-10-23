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
  final _isCpf = true.obs;

  bool get isCpf => _isCpf.value;

  LoginController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  void onSelected(bool value) {
    _isCpf.value = value;
  }

  Future<void> login({
    required value,
    required password,
  }) async {
    try {
      _loading.toggle();
      final userLogger = await _authServices.login(isCpf: isCpf, value: value, password: password);
      final storage = GetStorage();
      storage.write(Constants.USER_KEY, userLogger.id);
      _loading.toggle();
    } on AuthException catch (e, s) {
      log('Falha no login', error: e, stackTrace: s);
      _message(
        MessageModel(
          title: 'Falha no login',
          message:
              'CPF/CNPJ ou senha incorreta', // pode ser "Senha incorreta" ou outro texto vindo do service
          type: MessageType.error,
        ),
      );
    } catch (e) {
      _loading.toggle();
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao realizar login',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading(false);
    }
  }
}
