import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import './register_controller.dart';

class RegisterBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController(authServices: Get.find<AuthServices>()));
  }
}
