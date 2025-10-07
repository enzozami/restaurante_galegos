import 'dart:convert';

class UserModel {
  int id;
  String name;
  bool isCpf;
  String value;
  String password;

  UserModel({
    required this.id,
    required this.name,
    required this.isCpf,
    required this.value,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCpf': isCpf,
      'value': value,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      isCpf: map['isCpf'] ?? false,
      value: map['value'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
