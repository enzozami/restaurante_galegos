import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';
import './for_delivery_controller.dart';

class ForDeliveryBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      ForDeliveryController(
          orderFinishedServices: Get.find<OrderFinishedServices>(),
          ordersState: Get.find<OrdersState>()),
    );
  }
}
