import 'dart:convert';

import 'package:restaurante_galegos/app/models/shopping_card_model.dart';

class ItemCarrinho {
  int userId;
  String address;
  List<ShoppingCardModel> items;
  int quantity;
  String? selectSize;
  double? selectedPrice;

  ItemCarrinho({
    required this.userId,
    required this.address,
    required this.items,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'address': address,
      'items': items.map((e) => e.toMap()).toList(),
      'quantity': quantity,
    };
  }

  factory ItemCarrinho.fromMap(Map<String, dynamic> map) {
    return ItemCarrinho(
      userId: map['userId']?.toInt() ?? 0,
      address: map['address'] ?? '',
      items: List<ShoppingCardModel>.from(
          (map['items'] as List? ?? []).map((x) => ShoppingCardModel.fromMap(x))),
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemCarrinho.fromJson(String source) => ItemCarrinho.fromMap(json.decode(source));

  ItemCarrinho copyWith({
    int? userId,
    String? address,
    List<ShoppingCardModel>? items,
    int? quantity,
  }) {
    return ItemCarrinho(
      userId: userId ?? this.userId,
      address: address ?? this.address,
      items: items ?? this.items,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'ItemCarrinho(userId: $userId, address: $address, items: $items, quantity: $quantity)';
  }
}
