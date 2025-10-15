import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/order_model.dart';

import './order_reposiroty.dart';

class OrderReposirotyImpl implements OrderReposiroty {
  final RestClient _restClient;

  OrderReposirotyImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final result = await _restClient.post('/order', {
      'userId': order.userId,
      'value': order.value,
      'address': order.address,
      'items': order.items
          .map((shoppingCard) => {
                'quantity': shoppingCard.quantity,
                'product': shoppingCard.product,
                'food': shoppingCard.food,
              })
          .toList(),
    });

    if (result.hasError) {
      log(
        'Erro ao enviar novo pedido',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      RestClientException(message: 'Erro ao enviar novo pedido');
    }

    return OrderModel.fromMap(result.body);
  }
}
