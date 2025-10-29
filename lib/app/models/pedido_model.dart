import 'dart:convert';

import 'package:restaurante_galegos/app/models/carrinho_model.dart';

class PedidoModel {
  int id;
  int userId;
  int cep;
  String rua;
  String bairro;
  String cidade;
  String estado;
  int numeroResidencia; // numero da casa
  List<CarrinhoModel> cart;
  double amountToPay;
  PedidoModel({
    required this.id,
    required this.userId,
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.numeroResidencia,
    required this.cart,
    required this.amountToPay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cep': cep,
      'rua': rua,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'numeroResidencia': numeroResidencia,
      'cart': cart.map((x) => x.toMap()).toList(),
      'amountToPay': amountToPay,
    };
  }

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      id: map['id']?.toInt() ?? 0,
      userId: map['userId']?.toInt() ?? 0,
      cep: map['cep']?.toInt() ?? 0,
      rua: map['rua'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      numeroResidencia: map['numeroResidencia']?.toInt() ?? 0,
      cart: List<CarrinhoModel>.from(map['cart']?.map((x) => CarrinhoModel.fromMap(x)) ?? const []),
      amountToPay: map['amountToPay']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoModel.fromJson(String source) => PedidoModel.fromMap(json.decode(source));
}
