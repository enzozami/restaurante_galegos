import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

abstract interface class OrderReposiroty {
  Future<CarrinhoModel> createOrder(PedidoModel order);
  Future<PedidoModel> getIdOrder();
  Future<List<PedidoModel>> getOrder();
}
