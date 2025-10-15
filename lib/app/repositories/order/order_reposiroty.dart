import 'package:restaurante_galegos/app/models/order_model.dart';

abstract interface class OrderReposiroty {
  Future<OrderModel> createOrder(OrderModel order);
}
