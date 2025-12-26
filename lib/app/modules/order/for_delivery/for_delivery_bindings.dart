import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import './for_delivery_controller.dart';

class ForDeliveryBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl());
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()),
    );

    Get.lazyPut(
      () => ForDeliveryController(
        ordersState: Get.find<OrderServices>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
  }
}
