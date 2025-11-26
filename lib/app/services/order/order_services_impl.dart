import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';

import './order_services.dart';

class OrderServicesImpl implements OrderServices {
  final OrderReposiroty _orderReposiroty;

  final _all = <PedidoModel>[].obs;

  OrderServicesImpl({required OrderReposiroty orderRepository})
    : _orderReposiroty = orderRepository;

  @override
  RxList<PedidoModel> get all => _all;

  @override
  Future<OrderServices> init() async {
    await refreshOrders();
    return this;
  }

  @override
  Future<void> createOrder(PedidoModel order) async {
    await _orderReposiroty.createOrder(order);
    await refreshOrders();
  }

  @override
  Future<List<PedidoModel>> getOrder() => _orderReposiroty.getOrder();

  @override
  Future<String> generateSequentialOrderId() => _orderReposiroty.generateSequentialOrderId();

  @override
  Future<void> changeStatusFinished(PedidoModel pedido, String newTime) async {
    final index = _all.indexWhere((p) => p.id == pedido.id);
    if (index != -1) {
      await _orderReposiroty.changeStatusFinished(pedido, newTime);
      await refreshOrders();
    }
  }

  @override
  Future<void> changeStatusOnTheWay(PedidoModel pedido, String newTime) async {
    final index = _all.indexWhere((p) => p.id == pedido.id);
    if (index != -1) {
      await _orderReposiroty.changeStatusOnTheWay(pedido, newTime);
      await refreshOrders();
    }
  }

  Future<void> refreshOrders() async {
    _all.assignAll(await getOrder());
  }

  // PedidoModel _carrinhoModel() {
  //   return PedidoModel(
  //     id: id,
  //     userId: userId,
  //     userName: userName,
  //     cpfOrCnpj: cpfOrCnpj,
  //     cep: cep,
  //     rua: rua,
  //     bairro: bairro,
  //     cidade: cidade,
  //     estado: estado,
  //     numeroResidencia: numeroResidencia,
  //     taxa: taxa,
  //     cart: cart,
  //     amountToPay: amountToPay,
  //     status: status,
  //     date: date,
  //     time: time,
  //   );
}
