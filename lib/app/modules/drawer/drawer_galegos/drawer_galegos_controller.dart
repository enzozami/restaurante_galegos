import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class DrawerGalegosController extends GetxController {
  final AuthServices _authServices;

  RxString nome = ''.obs;
  RxString email = ''.obs;
  RxBool isAdmin = false.obs;

  final isPressed = false.obs;

  DrawerGalegosController({required AuthServices authServices}) : _authServices = authServices;

  @override
  void onInit() {
    super.onInit();
    nome = _authServices.nome;
    email = _authServices.email;
    isAdmin.value = _authServices.isAdmin();
  }

  void logout() => _authServices.logout();
}
