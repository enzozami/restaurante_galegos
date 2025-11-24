import 'dart:convert';

import 'package:flutter/widgets.dart';

class ProductModel {
  int id;
  String categoryId;
  String name;
  String? description;
  bool temHoje;
  double price;
  String image;
  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.temHoje,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'temHoje': temHoje,
      'price': price,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] is String ? int.parse(map['id']) : map['id'],
      categoryId: map['categoryId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      temHoje: map['temHoje'] ?? false,
      price: map['price']?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  ProductModel copyWith({
    int? id,
    String? categoryId,
    String? name,
    ValueGetter<String?>? description,
    bool? temHoje,
    double? price,
    String? image,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description != null ? description() : this.description,
      temHoje: temHoje ?? this.temHoje,
      price: price ?? this.price,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, categoryId: $categoryId, name: $name, description: $description, temHoje: $temHoje, price: $price, image: $image)';
  }
}
