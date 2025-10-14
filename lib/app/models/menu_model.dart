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
    final dayData = map['day'];
    final priceData = map['pricePerSize'];

    List<String> days = [];
    if (dayData is List) {
      days = dayData.map((e) {
        if (e is Map) return e['day'].toString();
        return e.toString();
      }).toList();
    } else if (dayData is String) {
      days = [dayData];
    }

    List<String> prices = [];
    if (priceData is List) {
      prices = priceData.map((e) {
        if (e is Map) return e['tamanho'].toString();
        return e.toString();
      }).toList();
    } else if (priceData is String) {
      prices = [priceData];
    }

    return MenuModel(day: days, pricePerSize: prices);
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source));
}
