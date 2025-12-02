import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';

class GalegosDrawerController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final OrderServices _orderServices;
  final AboutUsServices _aboutUsServices;
  final TimeServices _timeServices;

  final ScrollController scrollController = ScrollController();

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

  bool get isSelected => _isSelected.value;
  set isSelected(bool value) => _isSelected.value = value;

  final _name = ''.obs;
  String get name => _name.value;

  final _titleAboutUs = ''.obs;
  String get titleAboutUs => _titleAboutUs.value;
  final _textAboutUs = ''.obs;
  String get textAboutUs => _textAboutUs.value;

  // HISTÓRICO
  final history = <PedidoModel>[].obs;

  GalegosDrawerController({
    required AuthServices authServices,
    required AboutUsServices aboutUsServices,
    required TimeServices timeServices,
    required OrderServices orderServices,
  }) : _authServices = authServices,
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
    if (_isSelected.value == true) {}
  }

  Future<void> getUser() async {
    final userName = _authServices.getUserName();
    if (userName != null) {
      _name.value = userName;
    }
  }

  Future<void> updateName({required String name}) async {
    final user = _authServices.getUserName();
    if (user != null) {
      await _authServices.updateUserName(newName: name);
    }
  }

  Future<void> getAbout() async {
    _loading(true);
    try {
      final aboutUsData = await _aboutUsServices.getAboutUs();
      _titleAboutUs.value = aboutUsData.title;
      _textAboutUs.value = aboutUsData.text;
    } catch (e) {
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
      final userId = _authServices.getUserId();
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
