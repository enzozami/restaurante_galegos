import 'dart:convert';

class PasswordModel {
  final bool requireUppercase;
  final bool requireLowercase;
  final int minLength;
  PasswordModel({
    required this.requireUppercase,
    required this.requireLowercase,
    required this.minLength,
  });

  Map<String, dynamic> toMap() {
    return {
      'requireUppercase': requireUppercase,
      'requireLowercase': requireLowercase,
      'minLength': minLength,
    };
  }

  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      requireUppercase: map['requireUppercase'] ?? false,
      requireLowercase: map['requireLowercase'] ?? false,
      minLength: map['minLength']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordModel.fromJson(String source) => PasswordModel.fromMap(json.decode(source));
}
