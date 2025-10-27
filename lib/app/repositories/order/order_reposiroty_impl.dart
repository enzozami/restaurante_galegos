import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

import './order_reposiroty.dart';

class OrderReposirotyImpl implements OrderReposiroty {
  final RestClient _restClient;

  OrderReposirotyImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<CarrinhoModel> createOrder(PedidoModel order) async {
    final result = await _restClient.post('/orders', {
      'id': order.id,
      'userId': order.userId,
      'address': order.address,
      'cart': order.cart.map((e) => e.toMap()).toList(),
      'amountToPay': order.amountToPay,
    });

    if (result.hasError) {
      log(
        'Erro ao enviar novo pedido',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      RestClientException(message: 'Erro ao enviar novo pedido');
    }

    return CarrinhoModel.fromMap(result.body);
  }
}
