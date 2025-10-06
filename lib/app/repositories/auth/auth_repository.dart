import 'package:restaurante_galegos/app/core/enums/galegos_enum.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel> login(String user, GalegosEnum type, String password);
  Future<UserModel> register(String name, GalegosEnum type, String password);
}
