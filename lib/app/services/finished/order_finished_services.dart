import 'package:restaurante_galegos/app/models/order_finished_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

abstract interface class OrderFinishedServices {
  Future<OrderFinishedModel> orderFinished(PedidoModel pedido);
  Future<void> changeStatus(PedidoModel pedido);
  Future<List<OrderFinishedModel>> getOrderFinished();
}
