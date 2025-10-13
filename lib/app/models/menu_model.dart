import 'dart:convert';

import 'package:restaurante_galegos/app/models/day_model.dart';
import 'package:restaurante_galegos/app/models/price_per_size_model.dart';

class MenuModel {
  final List<DayModel> day;
  final List<PricePerSizeModel> pricePerSize;

  MenuModel({
    required this.day,
    required this.pricePerSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day.map((x) => x.toMap()).toList(),
      'pricePerSize': pricePerSize.map((x) => x.toMap()).toList(),
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      day: List<DayModel>.from(map['day']?.map((x) => DayModel.fromMap(x)) ?? const []),
      pricePerSize: List<PricePerSizeModel>.from(
          map['pricePerSize']?.map((x) => PricePerSizeModel.fromMap(x)) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) => MenuModel.fromMap(json.decode(source));
}
