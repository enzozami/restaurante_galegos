import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

abstract interface class OrderServices {
  RxList<PedidoModel> get all;

  Future<OrderServices> init();
  Future<void> createOrder(PedidoModel order);
  Future<List<PedidoModel>> getOrder();
  Future<String> generateSequentialOrderId();
  Future<void> changeStatusOnTheWay(PedidoModel pedido, String newTime);
  Future<void> changeStatusFinished(PedidoModel pedido, String newTime);
}
