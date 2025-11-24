import 'dart:convert';

class UserModel {
  int id;
  String name;
  bool? isCpf;
  bool? isAdmin;
  String email;
  String? cpfOrCnpj;
  String password;
  UserModel({
    required this.id,
    required this.name,
    this.isCpf,
    this.isAdmin,
    required this.email,
    this.cpfOrCnpj,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCpf': isCpf,
      'isAdmin': isAdmin,
      'email': email,
      'cpfOrCnpj': cpfOrCnpj,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      isCpf: map['isCpf'],
      isAdmin: map['isAdmin'],
      email: map['email'] ?? '',
      cpfOrCnpj: map['cpfOrCnpj'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
