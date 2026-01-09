import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class DrawerGalegosController extends GetxController {
  final AuthServices _authServices;

  RxString get nome => _authServices.nome;
  RxString get email => _authServices.email;
  bool get isAdmin => _authServices.isAdmin();

  final isPressed = false.obs;

  DrawerGalegosController({required AuthServices authServices}) : _authServices = authServices;

  void logout() => _authServices.logout();
}
