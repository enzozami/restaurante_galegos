import 'package:restaurante_galegos/app/models/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<void> resetPassword({required String email});
  Future<void> updateData(String? newName, String? newEmail, String? newPhone);
  Future<UserModel> getUser();
  Future<void> reauthenticate(String password);
}
