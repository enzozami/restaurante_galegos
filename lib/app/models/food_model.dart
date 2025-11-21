import 'dart:convert';

class FoodModel {
  int id;
  String name;
  bool temHoje;
  List<String> dayName;
  String description;
  Map<String, double> pricePerSize;
  String image;
  FoodModel({
    required this.id,
    required this.name,
    required this.temHoje,
    required this.dayName,
    required this.description,
    required this.pricePerSize,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'temHoje': temHoje,
      'dayName': dayName,
      'description': description,
      'pricePerSize': pricePerSize,
      'image': image,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      temHoje: map['temHoje'] ?? false,
      dayName: List<String>.from(map['dayName'] ?? const []),
      description: map['description'] ?? '',
      pricePerSize: Map<String, double>.from(map['pricePerSize'] ?? const {}),
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) => FoodModel.fromMap(json.decode(source));

  FoodModel copyWith({
    int? id,
    String? name,
    bool? temHoje,
    List<String>? dayName,
    String? description,
    Map<String, double>? pricePerSize,
    String? image,
  }) {
    return FoodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      temHoje: temHoje ?? this.temHoje,
      dayName: dayName ?? this.dayName,
      description: description ?? this.description,
      pricePerSize: pricePerSize ?? this.pricePerSize,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'FoodModel(id: $id, name: $name, temHoje: $temHoje, dayName: $dayName, description: $description, pricePerSize: $pricePerSize, image: $image)';
  }
}
