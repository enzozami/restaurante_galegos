import 'dart:convert';

class AlimentoModel {
  final String name;
  final String dayName;
  final String description;
  final Map<String, double> pricePerSizeMenu;

  AlimentoModel({
    required this.name,
    required this.dayName,
    required this.description,
    required this.pricePerSizeMenu,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dayName': dayName,
      'description': description,
      'pricePerSizeMenu': pricePerSizeMenu,
    };
  }

  factory AlimentoModel.fromMap(Map<String, dynamic> map) {
    return AlimentoModel(
      name: map['name'] ?? '',
      dayName: map['dayName'] ?? '',
      description: map['description'] ?? '',
      pricePerSizeMenu: Map<String, double>.from(map['pricePerSizeMenu'] ?? const {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory AlimentoModel.fromJson(String source) => AlimentoModel.fromMap(json.decode(source));
}
