import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import './login_controller.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(authServices: Get.find<AuthServices>()));
  }
}
