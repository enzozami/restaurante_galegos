import 'dart:convert';

import 'package:restaurante_galegos/app/models/carrinho_model.dart';

class PedidoModel {
  int id;
  int userId;
  String address;
  List<CarrinhoModel> cart;
  double amountToPay;
  PedidoModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.cart,
    required this.amountToPay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'address': address,
      'cart': cart.map((x) => x.toMap()).toList(),
      'amountToPay': amountToPay,
    };
  }

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      id: map['id']?.toInt() ?? 0,
      userId: map['userId']?.toInt() ?? 0,
      address: map['address'] ?? '',
      cart: List<CarrinhoModel>.from(map['cart']?.map((x) => CarrinhoModel.fromMap(x)) ?? const []),
      amountToPay: map['amountToPay']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoModel.fromJson(String source) => PedidoModel.fromMap(json.decode(source));
}
