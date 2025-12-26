import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/bottom_sheet/galegos_bottom_sheet.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';

class OrderManagementController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderServices _ordersState;
  final AuthServices _authServices;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> listOrders;

  bool get admin => _authServices.isAdmin();

  OrderManagementController({
    required OrderServices ordersState,
    required AuthServices authServices,
  }) : _ordersState = ordersState,
       _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    _ordersState.init();
    listOrders = firestore
        .collection('orders')
        .where('status', isEqualTo: 'preparando')
        .snapshots();
  }

  Future<void> orderFinished(PedidoModel pedido) async {
    final newTime = FormatterHelper.formatDateAndTime();
    await _ordersState.changeStatusOnTheWay(pedido, newTime);
  }

  void onAdminOrderTapped(PedidoModel pedido) {
    Get.bottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      isScrollControlled: true,
      GalegosBottomSheet(
        admin: admin,
        pedido: pedido,
        titleButtom: 'SAIR PARA ENTREGA',
        onPressed: () async {
          await orderFinished(pedido);
          Get.back();
        },
        ordersReceived: true,
      ),
    );
  }
}
