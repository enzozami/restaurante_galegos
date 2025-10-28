import 'dart:developer';

import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services.dart';
import 'package:restaurante_galegos/app/services/user/user_services.dart';

class GalegosDrawerController extends GetxController with LoaderMixin, MessagesMixin {
  final UserServices _userServices;
  final AuthService _authService;
  final AboutUsServices _aboutUsServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _isSelected = false.obs;
  final _isObscure = true.obs;

  bool get isSelected => _isSelected.value;
  set isSelected(bool value) => _isSelected.value = value;
  bool get isObscure => _isObscure.value;

  final _name = ''.obs;
  String get name => _name.value;
  final _password = ''.obs;
  String get password => _password.value;
  final valueCpfOrCnpj = ''.obs;

  final _titleAboutUs = ''.obs;
  String get titleAboutUs => _titleAboutUs.value;
  final _textAboutUs = ''.obs;
  String get textAboutUs => _textAboutUs.value;

  GalegosDrawerController({
    required UserServices userServices,
    required AuthService authService,
    required AboutUsServices aboutUsServices,
  })  : _userServices = userServices,
        _authService = authService,
        _aboutUsServices = aboutUsServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    getUser();
    getAbout();
  }

  void isSelect() {
    _isSelected.toggle();
  }

  Future<void> getUser() async {
    final userId = _authService.getUserId();
    if (userId != null) {
      final userData = await _userServices.getUser(id: userId);
      _name.value = userData.name;
      _password.value = userData.password;
      valueCpfOrCnpj.value = userData.value;
    }
  }

  Future<void> updateUser(
    String? name,
    String? password,
  ) async {
    final userId = _authService.getUserId();
    if (userId != null) {
      log(name ?? 'nome nao digitado');
      log(password ?? 'senha nao digitada');
      if (name != null && name != '' && password == '' && password != null) {
        await _userServices.updateUser(name, _password.value, id: userId);
      } else if (name != null && password != null && password != '') {
        await _userServices.updateUser(_name.value, password, id: userId);
      } else if (name != null && name != '' && password != null && password != '') {
        await _userServices.updateUser(name, password, id: userId);
      } else if (name != null && password != null && name == '' && password == '') {
        await _userServices.updateUser(_name.value, _password.value, id: userId);
      }
    }
  }

  Future<void> getAbout() async {
    _loading(true);
    try {
      final aboutUsData = await _aboutUsServices.getAboutUs();
      _titleAboutUs.value = aboutUsData.title;
      log('TITULO ABOUTTTTTT: ${_titleAboutUs.value}');
      _textAboutUs.value = aboutUsData.text;
      _loading(false);
    } catch (e) {
      _loading(false);
      _message(
        MessageModel(
          title: 'Erro ao buscar dados',
          message: 'Erro ao buscar o "sobre nós"',
          type: MessageType.error,
        ),
      );
      log(e.toString());
    } finally {
      _loading(false);
    }
  }
}
