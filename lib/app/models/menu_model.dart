import 'dart:convert';

class MenuModel {
  final List<String> day;
  final List<String> pricePerSize;
  MenuModel({
    required this.day,
    required this.pricePerSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'pricePerSize': pricePerSize,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      day: List<String>.from(map['day'] ?? const []),
      pricePerSize: List<String>.from(map['pricePerSize'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source));
}
