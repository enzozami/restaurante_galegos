import 'dart:convert';

class FoodModel {
  int id;
  String name;
  String dayName;
  String description;
  Map<String, double> pricePerSize;
  FoodModel({
    required this.id,
    required this.name,
    required this.dayName,
    required this.description,
    required this.pricePerSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dayName': dayName,
      'description': description,
      'pricePerSize': pricePerSize,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      dayName: map['dayName'] ?? '',
      description: map['description'] ?? '',
      pricePerSize: Map<String, double>.from(map['pricePerSize'] ?? const {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) => FoodModel.fromMap(json.decode(source));
}
