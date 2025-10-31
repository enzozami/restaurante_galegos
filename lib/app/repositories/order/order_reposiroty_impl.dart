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
    log('PEDIDO: ${order.toString()}');
    final result = await _restClient.post('/orders', {
      'id': order.id,
      'userId': order.userId,
      'cep': order.cep,
      'rua': order.rua,
      'bairro': order.bairro,
      'cidade': order.cidade,
      'estado': order.estado,
      'numeroResidencia': order.numeroResidencia,
      'taxa': order.taxa,
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

  @override
  Future<PedidoModel> getIdOrder() async {
    final result = await _restClient.get('/orders');

    if (result.hasError) {
      log('Id não encontrado', error: result.statusText, stackTrace: StackTrace.current);
      throw RestClientException(message: 'Id não encontrado;');
    }

    final data = result.body as List;
    return PedidoModel.fromMap(data.last);
  }

  @override
  Future<List<PedidoModel>> getOrder() async {
    final result = await _restClient.get('/orders');

    if (result.hasError) {
      log('Id não encontrado', error: result.statusText, stackTrace: StackTrace.current);
      throw RestClientException(message: 'Id não encontrado;');
    }
    final data = result.body as List;
    final list = data.map((e) => PedidoModel.fromMap(e)).toList();

    return list;
  }
}
