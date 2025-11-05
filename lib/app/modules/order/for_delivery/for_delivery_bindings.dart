import 'package:get/get.dart';
import './for_delivery_controller.dart';

class ForDeliveryBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ForDeliveryController());
  }
}
