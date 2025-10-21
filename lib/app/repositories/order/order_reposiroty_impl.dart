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
    final result = await _restClient.post('/orders', {
      'userId': order.userId,
      'address': order.address,
      'items': order.items
          .map((shoppingCard) => {
                'product': shoppingCard.product?.toMap(),
                'food': shoppingCard.food?.toMap(),
                'quantity': shoppingCard.quantity,
                'selectedSize': shoppingCard.selectSize,
                'selectedPrice': shoppingCard.selectedPrice,
              })
          .toList(),
    });

    if (result.hasError) {
      log(
        'Erro ao enviar novo pedido',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      throw RestClientException(message: 'Erro ao enviar novo pedido');
    }

    // CORREÇÃO: Tratar o caso em que o corpo (body) é nulo, mesmo sem 'hasError'
    if (result.body == null) {
      log('Corpo da resposta nulo após sucesso aparente.', stackTrace: StackTrace.current);
      throw RestClientException(message: 'Resposta vazia do servidor.');
    }

    return CardModel.fromMap(result.body);
  }
}
