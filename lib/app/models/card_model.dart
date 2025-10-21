import 'dart:convert';

import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

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
    return CardModel(
      id: map['id']?.toInt() ?? 0,
      items: List<ShoppingCardModel>.from(
          (map['items'] as List? ?? []).map((x) => ShoppingCardModel.fromMap(x))),
      amountToPay: map['amountToPay']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) => CardModel.fromMap(json.decode(source));

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
