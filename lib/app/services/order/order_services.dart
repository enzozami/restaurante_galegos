import 'package:restaurante_galegos/app/models/order_model.dart';

abstract interface class OrderServices {
  Future<OrderModel> createOrder(OrderModel order);
}
