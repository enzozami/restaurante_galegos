import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import './history_controller.dart';

class HistoryBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(
      () async => await OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()).init(),
    );
    Get.put(
      HistoryController(
        authServices: Get.find<AuthServices>(),
        ordersState: Get.find<OrderServices>(),
      ),
    );
  }
}
