import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';

class OrdersState extends GetxService {
  final OrderServices _orderServices;
  final all = <PedidoModel>[].obs;

  OrdersState({required OrderServices orderServices}) : _orderServices = orderServices;

  Future<OrdersState> init() async {
    await refreshOrders();
    return this;
  }

  Future<void> refreshOrders() async {
    final data = await _orderServices.getOrder();
    all.assignAll(data);
  }

  void update(PedidoModel pedido, String newStatus) async {
    final index = all.indexWhere((p) => p.id == pedido.id);
    if (index != -1) {
      all[index] = pedido.copyWith(status: newStatus);
      all.refresh();
    }
  }
}
