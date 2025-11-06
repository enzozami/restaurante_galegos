import 'package:restaurante_galegos/app/models/order_finished_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

abstract interface class OrderFinishedRepository {
  Future<OrderFinishedModel> orderFinished(PedidoModel pedido);
  Future<void> changeStatusOnTheWay(PedidoModel pedido);
  Future<void> changeStatusFinished(PedidoModel pedido);
  Future<List<OrderFinishedModel>> getOrderFinished();
}
