import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import './all_orders_controller.dart';

class AllOrdersBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl());
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()),
    );

    await Get.putAsync(
      () async => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()).init(),
    );

    Get.lazyPut<AllOrdersController>(
      () => AllOrdersController(
        ordersState: Get.find<OrderServices>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
  }
}
