import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

import './order_reposiroty.dart';

class OrderReposirotyImpl implements OrderReposiroty {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<CarrinhoModel> createOrder(PedidoModel order) async {
    try {
      final docRef = await firestore.collection('orders').add({
        'userId': order.userId,
        'userName': order.userName,
        'cpfOrCnpj': order.cpfOrCnpj,
        'cep': order.cep,
        'rua': order.rua,
        'bairro': order.bairro,
        'cidade': order.cidade,
        'estado': order.estado,
        'numeroResidencia': order.numeroResidencia,
        'taxa': order.taxa,
        'cart': order.cart.map((e) => e.toMap()).toList(),
        'amountToPay': order.amountToPay,
        'status': order.status,
        'time': order.time,
        'timeFinished': order.timeFinished,
        'date': order.date,
      });

      final snapshot = await docRef.get();
      return CarrinhoModel.fromMap({...snapshot.data()!, 'id': snapshot.id});
    } catch (e, s) {
      log('Erro ao realizar pedido', error: e, stackTrace: s);
      throw Exception('Erro ao realizar pedido');
    }
  }

  @override
  Future<List<PedidoModel>> getOrder() async {
    final snapshot = await firestore.collection('orders').get();
    return snapshot.docs.map((doc) => PedidoModel.fromMap({...doc.data(), 'id': doc.id})).toList();
  }

  @override
  Future<String> generateSequentialOrderId() async {
    final docRef = firestore.collection('configs').doc('pedido_counter');

    return firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception('Documento pedido_counter não existe.');
      }

      final data = snapshot.data()!;
      final lastId = data['lastId'] as int? ?? 0;

      final newId = lastId + 1;

      transaction.update(docRef, {'lastId': newId});
      return newId.toString();
    });
  }

  @override
  Future<void> changeStatusFinished(PedidoModel pedido) async {
    await firestore.collection('orders').doc(pedido.id.toString()).update({
      'status': 'entregue',
      'timeFinished': pedido.timeFinished,
    });
  }

  @override
  Future<void> changeStatusOnTheWay(PedidoModel pedido) async {
    await firestore.collection('orders').doc(pedido.id.toString()).update({
      'status': 'a caminho',
      'timeFinished': pedido.timePath,
    });
  }
}
