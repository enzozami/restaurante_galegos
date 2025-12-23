import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/enum/status.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';

class HistoryController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> get allOrders => (statusValue.value == Status.todos)
      ? firestore
            .collection('orders')
            .where('userId', isEqualTo: _authServices.getUserId())
            .orderBy('date', descending: true)
            .snapshots()
      : firestore
            .collection('orders')
            .where('userId', isEqualTo: _authServices.getUserId())
            .where('status', isEqualTo: getStatusName(statusValue.value).toLowerCase())
            .orderBy('date', descending: true)
            .snapshots();
  final RxBool isSelected = false.obs;
  final RxBool isProcessing = false.obs;
  final statusValue = Rx(Status.todos);

  final _loading = false.obs;
  RxBool get loading => _loading;
  final _message = Rxn<MessageModel>();

  final ScrollController scrollController = ScrollController();

  HistoryController({
    required AuthServices authServices,
    required OrderServices ordersState,
  }) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  String getStatusName(Status s) {
    switch (s) {
      case Status.todos:
        return 'Todos';
      case Status.preparando:
        return 'Preparando';
      case Status.caminho:
        return 'A Caminho';
      case Status.entregue:
        return 'Entregue';
    }
  }

  Future<void> searchOrdersByStatus(Status status) async {
    if (isProcessing.value) return;
    try {
      HapticFeedback.lightImpact();
      isProcessing.value = true;
      _loading.value = true;
      await 250.milliseconds.delay();

      if (statusValue.value == status) {
        statusValue.value = Status.todos;
      } else {
        statusValue.value = status;
      }
    } catch (e) {
      log('Erro ao filtrar: $e');
      _loading.value = false;
      await 250.milliseconds.delay();
      _message.value = MessageModel(
        title: 'Erro',
        message: 'Erro ao filtrar',
        type: MessageType.error,
      );
    } finally {
      _loading.value = false;
      isProcessing.value = false;
    }
  }

  Future<void> refreshOrders() async {
    _loading.value = true;
    await 500.milliseconds.delay();
    statusValue.value = Status.todos;
    _loading.value = false;
  }
}
