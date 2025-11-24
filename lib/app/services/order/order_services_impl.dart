import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';

import './order_services.dart';

class OrderServicesImpl implements OrderServices {
  final OrderReposiroty _orderReposiroty;

  OrderServicesImpl({required OrderReposiroty orderRepository})
    : _orderReposiroty = orderRepository;

  @override
  Future<CarrinhoModel> createOrder(PedidoModel order) => _orderReposiroty.createOrder(order);

  @override
  Future<PedidoModel> getIdOrder() => _orderReposiroty.getIdOrder();

  @override
  Future<List<PedidoModel>> getOrder() => _orderReposiroty.getOrder();

  @override
  Future<String> generateSequentialOrderId() => _orderReposiroty.generateSequentialOrderId();
}
