import 'package:restaurante_galegos/app/models/card_model.dart';
import 'package:restaurante_galegos/app/models/item_carrinho.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';

import './order_services.dart';

class OrderServicesImpl implements OrderServices {
  final OrderReposiroty _orderReposiroty;

  OrderServicesImpl({required OrderReposiroty orderRepository})
      : _orderReposiroty = orderRepository;

  @override
  Future<CardModel> createOrder(ItemCarrinho order) => _orderReposiroty.createOrder(order);
}
