import 'package:restaurante_galegos/app/models/user_model.dart';

abstract interface class AuthServices {
  Future<AuthServices> init();
  void logout();
  int? getUserId();
  String? getUserName();
  bool isAdmin();
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> resetPassword({required String email});
  Future<void> updateUserName({required String newName});
}
