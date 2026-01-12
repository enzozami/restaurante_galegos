import 'dart:convert';

class UserModel {
  String uid;
  String nome;
  bool isAdmin;
  String email;
  String phone;
  String password;
  UserModel({
    required this.uid,
    required this.nome,
    required this.isAdmin,
    required this.email,
    required this.phone,
    required this.password,
  });

  UserModel copyWith({
    String? uid,
    String? nome,
    bool? isAdmin,
    String? email,
    String? phone,
    String? password,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      isAdmin: isAdmin ?? this.isAdmin,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'isAdmin': isAdmin,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      nome: map['nome'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, nome: $nome, isAdmin: $isAdmin, email: $email, phone: $phone, password: $password)';
  }
}
