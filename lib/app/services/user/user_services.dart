import 'package:restaurante_galegos/app/models/user_model.dart';

abstract interface class UserServices {
  Future<UserModel> getUser({required int id});
}
