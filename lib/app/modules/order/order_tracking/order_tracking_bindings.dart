import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import './order_tracking_controller.dart';

class OrderTrackingBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl());
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()),
    );

    Get.lazyPut(
      () => OrderTrackingController(
        ordersState: Get.find<OrderServices>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
  }
}
