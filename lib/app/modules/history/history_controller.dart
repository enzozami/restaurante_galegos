import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

class HistoryController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthService _authService;
  final OrdersState _ordersState;

  final ScrollController scrollController = ScrollController();

  HistoryController({
    required AuthService authService,
    required OrdersState ordersState,
  })  : _authService = authService,
        _ordersState = ordersState;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final history = <PedidoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    getHistory();

    ever<List<PedidoModel>>(_ordersState.all, (_) {
      final id = _authService.getUserId();
      if (id != null) {
        final historyData = _ordersState.all.where((e) => e.userId == id);
        history.assignAll(historyData);
      }
    });
  }

  Future<void> getHistory() async {
    try {
      await _ordersState.refreshOrders();
      final id = _authService.getUserId();
      if (id != null) {
        final historyData = _ordersState.all.where((e) => e.userId == id);
        history.assignAll(historyData);
      }
    } catch (e) {
      log('ERROOO', error: e);
    }
  }

  // Future<void> refreshHistory() async {
  //   await getHistory();
  // }
}
