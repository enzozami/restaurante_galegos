import 'dart:convert';

class UserModel {
  String uid;
  String name;
  bool isAdmin;
  String email;
  String password;
  UserModel({
    required this.uid,
    required this.name,
    required this.isAdmin,
    required this.email,
    required this.password,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    bool? isAdmin,
    String? email,
    String? password,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      isAdmin: isAdmin ?? this.isAdmin,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'isAdmin': isAdmin,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
