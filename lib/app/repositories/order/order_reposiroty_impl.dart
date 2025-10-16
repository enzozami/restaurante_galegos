import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/card_model.dart';
import 'package:restaurante_galegos/app/models/item_carrinho.dart';

import './order_reposiroty.dart';

class OrderReposirotyImpl implements OrderReposiroty {
  final RestClient _restClient;

  OrderReposirotyImpl({required RestClient restClient}) : _restClient = restClient;

  @override
  Future<CardModel> createOrder(ItemCarrinho order) async {
    final result = await _restClient.post('/order', {
      'userId': order.userId,
      'address': order.address,
      'items': order.items
          .map((shoppingCard) => {
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

    return CardModel.fromMap(result.body);
  }
}
