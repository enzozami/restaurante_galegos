import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';

class GalegosDrawerBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GalegosDrawerController());
  }
}
