import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:restaurante_galegos/app/models/carrinho_model.dart';

class PedidoModel {
  PedidoModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.numeroResidencia,
    required this.taxa,
    required this.cart,
    required this.amountToPay,
    required this.status,
    required this.date,
    required this.time,
    this.timePath,
    this.timeFinished,
  });

  String id;
  String userId;
  String userName;
  String cep;
  String rua;
  String bairro;
  String cidade;
  String estado;
  int numeroResidencia;
  double taxa;
  List<CarrinhoModel> cart;
  double amountToPay;
  String status;
  String date;
  String time;
  String? timePath;
  String? timeFinished;

  PedidoModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? cep,
    String? rua,
    String? bairro,
    String? cidade,
    String? estado,
    int? numeroResidencia,
    double? taxa,
    List<CarrinhoModel>? cart,
    double? amountToPay,
    String? status,
    String? date,
    String? time,
    ValueGetter<String?>? timePath,
    ValueGetter<String?>? timeFinished,
  }) {
    return PedidoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      numeroResidencia: numeroResidencia ?? this.numeroResidencia,
      taxa: taxa ?? this.taxa,
      cart: cart ?? this.cart,
      amountToPay: amountToPay ?? this.amountToPay,
      status: status ?? this.status,
      date: date ?? this.date,
      time: time ?? this.time,
      timePath: timePath != null ? timePath() : this.timePath,
      timeFinished: timeFinished != null ? timeFinished() : this.timeFinished,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'cep': cep,
      'rua': rua,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'numeroResidencia': numeroResidencia,
      'taxa': taxa,
      'cart': cart.map((x) => x.toMap()).toList(),
      'amountToPay': amountToPay,
      'status': status,
      'date': date,
      'time': time,
      'timePath': timePath,
      'timeFinished': timeFinished,
    };
  }

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      id: map['id'] ?? '',
      userId: map['userId']?.toString() ?? '',
      userName: map['userName'] ?? '',
      cep: map['cep'] ?? '',
      rua: map['rua'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      numeroResidencia: map['numeroResidencia']?.toInt() ?? 0,
      taxa: map['taxa']?.toDouble() ?? 0.0,
      cart: List<CarrinhoModel>.from(map['cart']?.map((x) => CarrinhoModel.fromMap(x)) ?? const []),
      amountToPay: map['amountToPay']?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      timePath: map['timePath'],
      timeFinished: map['timeFinished'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoModel.fromJson(String source) => PedidoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return '--- Detalhes do Pedido ---\n'
        'ID: $id\n'
        'Usuário: $userName ($userId)\n'
        'Status: $status\n'
        'Total a Pagar: R\$${amountToPay.toStringAsFixed(2)} (Taxa: R\$${taxa.toStringAsFixed(2)})\n'
        'Data/Hora: $date às $time\n'
        '--- Endereço ---\n'
        'CEP: $cep\n'
        'Rua: $rua, Nº: $numeroResidencia\n'
        'Bairro: $bairro\n'
        'Cidade/Estado: $cidade/$estado\n'
        '--- Itens no Carrinho (${cart.length} itens) ---\n'
        '${_formatCartItems()}\n'
        '----------------------------';
  }

  String _formatCartItems() {
    if (cart.isEmpty) return 'Carrinho vazio.';
    return cart
        .map((item) {
          return '  - ${item.item.quantidade}x ${item.item.alimento?.name ?? item.item.produto?.name ?? 'Produto sem nome'}';
        })
        .join('\n');
  }
}
