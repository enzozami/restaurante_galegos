import 'dart:convert';

import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';

class ShoppingCardModel {
  int quantity;
  ItemModel? product;
  AlimentoModel? food;

  ShoppingCardModel({
    required this.quantity,
    this.product,
    this.food,
  });

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'product': product?.toMap(),
      'food': food?.toMap(),
    };
  }

  factory ShoppingCardModel.fromMap(Map<String, dynamic> map) {
    return ShoppingCardModel(
      quantity: map['quantity']?.toInt() ?? 0,
      product: map['product'] != null ? ItemModel.fromMap(map['product']) : null,
      food: map['food'] != null ? AlimentoModel.fromMap(map['food']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingCardModel.fromJson(String source) =>
      ShoppingCardModel.fromMap(json.decode(source));
}
