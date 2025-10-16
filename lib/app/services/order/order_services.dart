import 'package:restaurante_galegos/app/models/order_finished.dart';
import 'package:restaurante_galegos/app/models/order_model.dart';

abstract interface class OrderServices {
  Future<OrderFinished> createOrder(OrderModel order);
}
