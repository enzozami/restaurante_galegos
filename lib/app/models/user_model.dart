import 'dart:convert';

class UserModel {
  int id;
  String name;
  bool isCpf;
  bool isAdmin;
  String value;
  String password;

  UserModel({
    required this.id,
    required this.name,
    required this.isCpf,
    required this.isAdmin,
    required this.value,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCpf': isCpf,
      'isAdmin': isAdmin,
      'value': value,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      isCpf: map['isCpf'] ?? false,
      isAdmin: map['isAdmin'] ?? false,
      value: map['value'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
