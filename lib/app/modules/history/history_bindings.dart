import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import './history_controller.dart';

class HistoryBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(
      () async => await OrdersState(orderServices: Get.find<OrderServices>()).init(),
    );
    Get.put(
      HistoryController(
        authServices: Get.find<AuthServices>(),
        ordersState: Get.find<OrdersState>(),
      ),
    );
  }
}
