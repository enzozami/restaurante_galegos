import 'dart:convert';

class AlimentoModel {
  final int id;
  final String name;
  final String dayName;
  final String description;
  final Map<String, double> pricePerSize;
  AlimentoModel({
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

  factory AlimentoModel.fromMap(Map<String, dynamic> map) {
    return AlimentoModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      dayName: map['dayName'] ?? '',
      description: map['description'] ?? '',
      pricePerSize: Map<String, double>.from(map['pricePerSize'] ?? const {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory AlimentoModel.fromJson(String source) => AlimentoModel.fromMap(json.decode(source));
}
