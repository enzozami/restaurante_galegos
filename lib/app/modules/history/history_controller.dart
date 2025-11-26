import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class HistoryController extends GetxController with LoaderMixin, MessagesMixin {
  final AuthServices _authServices;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> allOrders;

  final ScrollController scrollController = ScrollController();

  HistoryController({required AuthServices authServices, required OrdersState ordersState})
    : _authServices = authServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);

    allOrders = firestore
        .collection('orders')
        .where('userId', isEqualTo: _authServices.getUserId())
        .orderBy('date', descending: true)
        .snapshots();
  }
}
