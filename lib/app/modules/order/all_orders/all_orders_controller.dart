import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';

class AllOrdersController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderServices _ordersState;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> listOrders;

  AllOrdersController({required OrderServices ordersState}) : _ordersState = ordersState;

  @override
  void onInit() {
    super.onInit();
    _ordersState.init();
    listOrders = firestore
        .collection('orders')
        .where('status', isEqualTo: 'preparando')
        .snapshots();
  }

  void orderFinished(PedidoModel pedido) async {
    final newTime = FormatterHelper.formatDateAndTime();
    _ordersState.changeStatusOnTheWay(pedido, newTime);
  }
}
