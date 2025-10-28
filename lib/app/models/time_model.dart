import 'dart:convert';

class TimeModel {
  List<String> days;
  String inicio;
  String fim;
  TimeModel({
    required this.days,
    required this.inicio,
    required this.fim,
  });

  Map<String, dynamic> toMap() {
    return {
      'days': days,
      'inicio': inicio,
      'fim': fim,
    };
  }

  factory TimeModel.fromMap(Map<String, dynamic> map) {
    return TimeModel(
      days: List<String>.from(map['days'] ?? const []),
      inicio: map['inicio'] ?? '',
      fim: map['fim'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeModel.fromJson(String source) => TimeModel.fromMap(json.decode(source));
}
