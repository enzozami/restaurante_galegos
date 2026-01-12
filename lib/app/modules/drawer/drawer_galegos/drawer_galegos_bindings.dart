import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import './drawer_galegos_controller.dart';

class DrawerGalegosBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DrawerGalegosController(authServices: Get.find<AuthServices>()));
  }
}
