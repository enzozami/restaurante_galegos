import 'dart:convert';

import 'package:restaurante_galegos/app/models/item_carrinho.dart';

class CardModel {
  String id;
  List<ItemCarrinho> productsSelected;
  double amountToPay;
  CardModel({
    required this.id,
    required this.productsSelected,
    required this.amountToPay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productsSelected': productsSelected.map((x) => x.toMap()).toList(),
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
      id: map['id']?.toString() ?? '',
      productsSelected: parsedProducts,
      amountToPay: (map['amountToPay'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) =>
      CardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CardModel copyWith({
    String? id,
    List<ItemCarrinho>? productsSelected,
    double? amountToPay,
  }) {
    return CardModel(
      id: id ?? this.id,
      productsSelected: productsSelected ?? this.productsSelected,
      amountToPay: amountToPay ?? this.amountToPay,
    );
  }
}
