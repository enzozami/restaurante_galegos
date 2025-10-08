import 'dart:convert';

import 'package:restaurante_galegos/app/models/item_model.dart';

class ProductModel {
  int id;
  String category;
  List<ItemModel> item;
  ProductModel({
    required this.id,
    required this.category,
    required this.item,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'item': item.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt() ?? 0,
      category: map['category'] ?? '',
      item: List<ItemModel>.from(map['item']?.map((x) => ItemModel.fromMap(x)) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));
}
