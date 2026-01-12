import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class DrawerGalegosController extends GetxController {
  final AuthServices _authServices;

  String get nome => _authServices.nome.value;
  String get email => _authServices.email.value;
  bool get isAdmin => _authServices.isAdmin();

  DrawerGalegosController({required AuthServices authServices}) : _authServices = authServices;

  void logout() => _authServices.logout();
}
