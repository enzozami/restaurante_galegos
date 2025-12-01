import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurante_galegos/app/core/constants/constants.dart';
import 'package:restaurante_galegos/app/core/masks/mask_cpf.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/password_model.dart';
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

  final isSelected = true.obs;
  final isSelectedConfirmaSenha = true.obs;

  final _regrasObs = <String>[].obs;
  List<String> get regras => _regrasObs.value;

  RegisterController({required AuthServices authServices}) : _authServices = authServices;

  @override
  Future<void> onInit() async {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    final policy = await _authServices.initPassword();
    _regrasSenha(policy);
  }

  void onSelected(bool value) {
    _isChecked.value = value;
    _isCpf.value = !value;
  }

  void seePassword() {
    isSelected.value = !isSelected.value;
  }

  void seeConfirmaPassword() {
    isSelectedConfirmaSenha.value = !isSelectedConfirmaSenha.value;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _loading.value = true;
      final userLogged = await _authServices.register(
        isCpf: isCpf,
        name: name,
        email: email,
        password: password,
      );
      final storage = GetStorage();
      storage.write(Constants.USER_KEY, userLogged.id);
      storage.write(Constants.ADMIN_KEY, false);
      storage.write(Constants.USER_NAME, userLogged.name);
      storage.write(Constants.USER_CPFORCNPJ, userLogged.cpfOrCnpj);
      _loading.toggle();
    } catch (e, s) {
      _loading.toggle();
      log(e.toString());
      log(s.toString());
      _message(
        MessageModel(title: 'Erro', message: 'Erro ao cadastrar usuário', type: MessageType.error),
      );
    } finally {
      _loading.value = false;
    }
  }

  List<String> _regrasSenha(PasswordModel policy) {
    regras.add('Mínimo de ${policy.minLength} caracteres');
    if (policy.requireLowercase) regras.add('Pelo menos uma letra minúscula.');
    if (policy.requireUppercase) regras.add('Pelo menos uma letra maiúscula.');

    return regras;
  }
}
