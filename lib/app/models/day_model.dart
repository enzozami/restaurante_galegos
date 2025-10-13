import 'dart:convert';

class DayModel {
  final String day;
  DayModel({
    required this.day,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
    };
  }

  factory DayModel.fromMap(Map<String, dynamic> map) {
    return DayModel(
      day: map['day'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DayModel.fromJson(String source) => DayModel.fromMap(json.decode(source));
}
