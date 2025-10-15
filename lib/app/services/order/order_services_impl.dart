import 'package:restaurante_galegos/app/models/order_model.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';

import './order_services.dart';

class OrderServicesImpl implements OrderServices {
  final OrderReposiroty _orderReposiroty;

  OrderServicesImpl({required OrderReposiroty orderRepository})
      : _orderReposiroty = orderRepository;

  @override
  Future<OrderModel> createOrder(OrderModel order) => _orderReposiroty.createOrder(order);
}
