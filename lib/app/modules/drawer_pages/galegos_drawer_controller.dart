import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';
import 'package:restaurante_galegos/app/services/user/user_services.dart';

class GalegosDrawerController extends GetxController with LoaderMixin, MessagesMixin {
  final UserServices _userServices;
  final AuthService _authService;
  final OrderServices _orderServices;
  final AboutUsServices _aboutUsServices;
  final TimeServices _timeServices;

  final ScrollController scrollController = ScrollController();

  final isPasswordSee = true.obs;
  final senha = false.obs;

  void atualizarSenha() {
    senha.value = !senha.value;
  }

  final dayNow = FormatterHelper.formatDate();
  final _dateTime = <String>[].obs;
  final _inicioTime = ''.obs;
  final _fimTime = ''.obs;

  List<String> get dateTime => _dateTime.value;
  String get inicioTime => _inicioTime.value;
  String get fimTime => _fimTime.value;

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

  // HISTÓRICO
  final history = <PedidoModel>[].obs;

  GalegosDrawerController({
    required UserServices userServices,
    required AuthService authService,
    required AboutUsServices aboutUsServices,
    required TimeServices timeServices,
    required OrderServices orderServices,
  }) : _userServices = userServices,
       _authService = authService,
       _aboutUsServices = aboutUsServices,
       _timeServices = timeServices,
       _orderServices = orderServices;

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
    time();
    getHistory();
  }

  void isSelect() {
    _isSelected.toggle();
    if (_isSelected.value == true) {
      senha.value = false;
    }
  }

  void seePassword() {
    isPasswordSee.value = !isPasswordSee.value;
  }

  Future<void> getUser() async {
    final userId = _authService.getUserId();
    if (userId != null) {
      final userData = await _userServices.getUser(id: userId);
      _name.value = userData.name;
      _password.value = userData.password;
      valueCpfOrCnpj.value = userData.cpfOrCnpj ?? '';
    }
  }

  Future<void> updateUser(String? name, String? password) async {
    final userId = _authService.getUserId();
    if (userId != null) {
      log(name ?? 'nome nao digitado');
      log(password ?? 'senha nao digitada');
      if (name != null && name != '' && password == '' && password != null) {
        await _userServices.updateUser(name, _password.value, id: userId);
      } else if (name != null && name == '' && password != null && password != '') {
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

  Future<void> time() async {
    _loading(true);
    final timeData = await _timeServices.getTime();

    final data = timeData.where((e) => e.days.contains(dayNow));

    _dateTime.assignAll(data.first.days);
    _inicioTime.value = data.first.inicio;
    _fimTime.value = data.first.fim;
  }

  // HISTÓRICO
  Future<void> getHistory() async {
    _loading(true);
    try {
      final userId = _authService.getUserId();
      if (userId != null) {
        final historyData = await _orderServices.getOrder();
        final items = historyData.where((e) => e.userId == userId);
        history.assignAll(items);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      _loading(false);
    }
  }
}
