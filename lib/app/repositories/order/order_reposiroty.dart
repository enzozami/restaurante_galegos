import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

abstract interface class OrderReposiroty {
  Future<CarrinhoModel> createOrder(PedidoModel order);
  Future<List<PedidoModel>> getOrder();
  Future<String> generateSequentialOrderId();
  Future<void> changeStatusOnTheWay(PedidoModel pedido);
  Future<void> changeStatusFinished(PedidoModel pedido);
}
