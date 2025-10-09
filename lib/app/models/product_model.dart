import 'dart:convert';

import 'package:restaurante_galegos/app/models/item_model.dart';

class ProductModel {
  int id;
  String category;
  List<ItemModel> items;
  ProductModel({
    required this.id,
    required this.category,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt() ?? 0,
      category: map['category'] ?? '',
      items: List<ItemModel>.from(map['items']?.map((x) => ItemModel.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));
}
