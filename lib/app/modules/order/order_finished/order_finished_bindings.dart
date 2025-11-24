import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import './order_finished_controller.dart';

class OrderFinishedBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(OrderFinishedController(ordersState: Get.find<OrdersState>()));
  }
}
