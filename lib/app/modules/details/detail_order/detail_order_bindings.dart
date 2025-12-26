import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'detail_order_controller.dart';

class DetailOrderBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DetailOrderController(authServices: Get.find<AuthServices>()));
  }
}
