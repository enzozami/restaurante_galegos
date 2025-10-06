import 'dart:convert';

class UserModel {
  int id;
  String name;
  String? cpf;
  String? cnpj;
  String password;
  UserModel({
    required this.id,
    required this.name,
    this.cpf,
    this.cnpj,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'cnpj': cnpj,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      cpf: map['cpf']?.toInt(),
      cnpj: map['cnpj']?.toInt(),
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
