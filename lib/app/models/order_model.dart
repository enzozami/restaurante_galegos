import 'dart:convert';

import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class OrderModel {
  int userId;
  String address;
  List<ShoppingCardModel> items;

  OrderModel({
    required this.userId,
    required this.address,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'address': address,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId']?.toInt() ?? 0,
      address: map['address'] ?? '',
      items: List<ShoppingCardModel>.from(
          map['items']?.map((x) => ShoppingCardModel.fromMap(x)) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));
}
