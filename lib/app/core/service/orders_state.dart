import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/item.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/items/items_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';

class OrdersState extends GetxService {
  final OrderServices _orderServices;
  final all = <PedidoModel>[].obs;
  final ItemsServices _itemsServices;

  OrdersState({required OrderServices orderServices, required ItemsServices itemsServices})
      : _orderServices = orderServices,
        _itemsServices = itemsServices;

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

  Future<void> updateTemHoje(int id, Item item) async {
    final novoValor = !item.temHoje;
    await _itemsServices.updateTemHoje(id, item, novoValor);
  }
}
