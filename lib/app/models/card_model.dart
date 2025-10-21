import 'dart:convert';

import 'package:restaurante_galegos/app/models/item_carrinho.dart';

class CardModel {
  int id;
  List<ShoppingCardModel> items;
  double amountToPay;
  CardModel({
    required this.id,
    required this.items,
    required this.amountToPay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((x) => x.toMap()).toList(),
      'amountToPay': amountToPay,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    final rawProducts = map['productsSelected'];
    List<ItemCarrinho> parsedProducts = [];

    if (rawProducts is List) {
      parsedProducts = rawProducts.map<ItemCarrinho>((x) {
        if (x is ItemCarrinho) return x;
        if (x is Map) return ItemCarrinho.fromMap(Map<String, dynamic>.from(x));
        // fallback: try decode if it's a json string
        if (x is String) {
          final decoded = json.decode(x);
          return ItemCarrinho.fromMap(Map<String, dynamic>.from(decoded));
        }
        throw FormatException('Formato inválido em productsSelected');
      }).toList();
    }

    return CardModel(
      id: map['id']?.toInt() ?? 0,
      items: List<ShoppingCardModel>.from(
          (map['items'] as List? ?? []).map((x) => ShoppingCardModel.fromMap(x))),
      amountToPay: map['amountToPay']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) =>
      CardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CardModel copyWith({
    int? id,
    List<ShoppingCardModel>? items,
    double? amountToPay,
  }) {
    return CardModel(
      id: id ?? this.id,
      items: items ?? this.items,
      amountToPay: amountToPay ?? this.amountToPay,
    );
  }
}
