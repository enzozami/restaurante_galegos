import 'dart:convert';

import 'package:restaurante_galegos/app/models/alimento_model.dart';
import 'package:restaurante_galegos/app/models/item_model.dart';

class ShoppingCardModel {
  ItemModel? product;
  AlimentoModel? food;
  String? selectSize;
  double? selectedPrice;
  int quantity;
  ShoppingCardModel({
    this.product,
    this.food,
    this.selectSize,
    this.selectedPrice,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product?.toMap(),
      'food': food?.toMap(),
      'selectSize': selectSize,
      'selectedPrice': selectedPrice,
      'quantity': quantity,
    };
  }

  factory ShoppingCardModel.fromMap(Map<String, dynamic> map) {
    return ShoppingCardModel(
      product: map['product'] != null ? ItemModel.fromMap(map['product']) : null,
      food: map['food'] != null ? AlimentoModel.fromMap(map['food']) : null,
      selectSize: map['selectSize'],
      selectedPrice: map['selectedPrice']?.toDouble(),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShoppingCardModel.fromJson(String source) =>
      ShoppingCardModel.fromMap(json.decode(source));
}
