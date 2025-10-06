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
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'password': password,
    };

    if (cpf != null) map['cpf'] = cpf;
    if (cnpj != null) map['cnpj'] = cnpj;

    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      cpf: map['cpf']?.toString(),
      cnpj: map['cnpj']?.toString(),
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
