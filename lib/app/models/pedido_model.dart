import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:restaurante_galegos/app/models/carrinho_model.dart';
import 'package:restaurante_galegos/app/models/endereco_model.dart';

class PedidoModel {
  String id;
  String userId;
  String userName;
  EnderecoModel endereco;
  double taxa;
  List<CarrinhoModel> cart;
  double amountToPay;
  String status;
  String date;
  String time;
  String? timePath;
  String? timeFinished;
  String formaPagamento;
  PedidoModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.endereco,
    required this.taxa,
    required this.cart,
    required this.amountToPay,
    required this.status,
    required this.date,
    required this.time,
    this.timePath,
    this.timeFinished,
    required this.formaPagamento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'endereco': endereco.toMap(),
      'taxa': taxa,
      'cart': cart.map((x) => x.toMap()).toList(),
      'amountToPay': amountToPay,
      'status': status,
      'date': date,
      'time': time,
      'timePath': timePath,
      'timeFinished': timeFinished,
      'formaPagamento': formaPagamento,
    };
  }

  factory PedidoModel.fromMap(Map<String, dynamic> map) {
    return PedidoModel(
      id: map['id'] ?? '',
      userId: map['userId'].toString(),
      userName: map['userName'] ?? '',
      endereco: EnderecoModel.fromMap(map['endereco'] as Map<String, dynamic>? ?? {}),
      taxa: map['taxa']?.toDouble() ?? 0.0,
      cart: List<CarrinhoModel>.from(map['cart']?.map((x) => CarrinhoModel.fromMap(x)) ?? const []),
      amountToPay: map['amountToPay']?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      timePath: map['timePath'],
      timeFinished: map['timeFinished'],
      formaPagamento: map['formaPagamento'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoModel.fromJson(String source) => PedidoModel.fromMap(json.decode(source));

  PedidoModel copyWith({
    String? id,
    String? userId,
    String? userName,
    EnderecoModel? endereco,
    double? taxa,
    List<CarrinhoModel>? cart,
    double? amountToPay,
    String? status,
    String? date,
    String? time,
    ValueGetter<String?>? timePath,
    ValueGetter<String?>? timeFinished,
    String? formaPagamento,
  }) {
    return PedidoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      endereco: endereco ?? this.endereco,
      taxa: taxa ?? this.taxa,
      cart: cart ?? this.cart,
      amountToPay: amountToPay ?? this.amountToPay,
      status: status ?? this.status,
      date: date ?? this.date,
      time: time ?? this.time,
      timePath: timePath != null ? timePath() : this.timePath,
      timeFinished: timeFinished != null ? timeFinished() : this.timeFinished,
      formaPagamento: formaPagamento ?? this.formaPagamento,
    );
  }

  @override
  String toString() {
    return 'PedidoModel(id: $id, userId: $userId, userName: $userName, endereco: $endereco, taxa: $taxa, cart: $cart, amountToPay: $amountToPay, status: $status, date: $date, time: $time, timePath: $timePath, timeFinished: $timeFinished, formaPagamento: $formaPagamento)';
  }
}
