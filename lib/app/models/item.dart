import 'dart:convert';

class Item {
  int id;
  String categoryId;
  String name;
  String? description;
  bool temHoje;
  double price;
  Item({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.temHoje,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'temHoje': temHoje,
      'price': price,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id']?.toInt() ?? 0,
      categoryId: map['categoryId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      temHoje: map['temHoje'] ?? false,
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));
}
