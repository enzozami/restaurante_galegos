import 'dart:convert';

import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class CardModel {
  int id;
  List<ShoppingCardModel> productsSelected;
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
    return CardModel(
      id: map['id']?.toInt() ?? 0,
      productsSelected: List<ShoppingCardModel>.from(
          map['productsSelected']?.map((x) => ShoppingCardModel.fromMap(x)) ?? const []),
      amountToPay: map['amountToPay']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) => CardModel.fromMap(json.decode(source));

  CardModel copyWith({
    int? id,
    List<ShoppingCardModel>? productsSelected,
    double? amountToPay,
  }) {
    return CardModel(
      id: id ?? this.id,
      productsSelected: productsSelected ?? this.productsSelected,
      amountToPay: amountToPay ?? this.amountToPay,
    );
  }
}
