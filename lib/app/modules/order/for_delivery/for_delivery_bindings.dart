import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import './for_delivery_controller.dart';

class ForDeliveryBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      ForDeliveryController(
          orderServices: Get.find<OrderServices>(),
          orderFinishedServices: Get.find<OrderFinishedServices>()),
    );
  }
}
