import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import './history_controller.dart';

class HistoryBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(
      () async => await OrdersState(
        orderServices: Get.find<OrderServices>(),
      ).init(),
    );
    Get.put(
      HistoryController(
        authService: Get.find<AuthService>(),
        ordersState: Get.find<OrdersState>(),
      ),
    );
  }
}
