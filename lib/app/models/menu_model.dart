import 'dart:convert';

class MenuModel {
  final String day;
  final String pricePerSize;
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
      day: map['day'] ?? '',
      pricePerSize: map['pricePerSize'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source));
}
