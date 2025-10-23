import 'package:restaurante_galegos/app/models/user_model.dart';

abstract interface class UserRepository {
  Future<UserModel> getUser({required int id});
  Future<UserModel> updateUser(
    String name,
    String password, {
    required int id,
  });
}
