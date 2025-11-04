import 'dart:convert';

import 'package:restaurante_galegos/app/models/pedido_model.dart';

class OrderFinishedModel {
  PedidoModel pedido;
  OrderFinishedModel({
    required this.pedido,
  });

  Map<String, dynamic> toMap() {
    return {
      'pedido': pedido.toMap(),
    };
  }

  factory OrderFinishedModel.fromMap(Map<String, dynamic> map) {
    return OrderFinishedModel(
      pedido: PedidoModel.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderFinishedModel.fromJson(String source) =>
      OrderFinishedModel.fromMap(json.decode(source));
}
