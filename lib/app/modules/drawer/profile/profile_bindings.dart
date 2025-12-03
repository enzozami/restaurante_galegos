import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import './profile_controller.dart';

class ProfileBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController(authServices: Get.find<AuthServices>()));
  }
}
