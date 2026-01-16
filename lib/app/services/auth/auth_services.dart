import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:restaurante_galegos/app/models/user_model.dart';

abstract interface class AuthServices {
  Future<AuthServices> init();
  Future<bool> openOrClosedRestaurant();
  void logout();
  String? getUserId();
  Future<UserModel> getUser();
  Future<UserModel> login({
    required String email,
    required String password,
  });
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<void> resetPassword({required String email});
  Future<void> updateData(
    String? newName,
    String? newEmail,
    String? newPhone,
  );
  Future<void> reauthenticate(String password);
  RxString get nome;
  RxString get email;
  bool isAdmin();
  Future<List<BiometricType>> initBiometrics();
  Future<bool> auth();
  Future<void> showClosedSnackbar();
}
