import 'dart:developer';

import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/models/order_finished_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

import './order_finished_repository.dart';

class OrderFinishedRepositoryImpl implements OrderFinishedRepository {
  final RestClient _restClient;

  OrderFinishedRepositoryImpl({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<OrderFinishedModel> orderFinished(PedidoModel pedido) async {
    final result = await _restClient.post('/finished', {
      'id': pedido.id,
      'userId': pedido.userId,
      'userName': pedido.userName,
      'cpfOrCnpj': pedido.cpfOrCnpj,
      'cep': pedido.cep,
      'rua': pedido.rua,
      'bairro': pedido.bairro,
      'cidade': pedido.cidade,
      'estado': pedido.estado,
      'numeroResidencia': pedido.numeroResidencia,
      'taxa': pedido.taxa,
      'cart': pedido.cart.map((e) => e.toMap()).toList(),
      'amountToPay': pedido.amountToPay,
      'status': pedido.status,
      'time': pedido.time,
      'date': pedido.date,
      'timeFinished': pedido.timeFinished
    });

    if (result.hasError) {
      log(
        'Erro ao finalizar pedido',
        error: result.statusText,
        stackTrace: StackTrace.current,
      );
      throw RestClientException(message: 'Erro ao finalizar pedido');
    }

    final finished = OrderFinishedModel.fromMap((result.body as Map<String, dynamic>));
    return finished;
  }

  @override
  Future<void> changeStatus(PedidoModel pedido) async {
    final result = await _restClient.patch('/orders/${pedido.id}', {
      'status': 'finalizado',
      'timeFinished': pedido.time,
    });

    if (result.hasError) {}
  }
}
