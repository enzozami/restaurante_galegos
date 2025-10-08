import 'dart:convert';

class ItemModel {
  int id;
  String name;
  String? description;
  double price;
  ItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) => ItemModel.fromMap(json.decode(source));
}
