import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
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
    Get.lazyPut<OrdersState>(() => OrdersState(orderServices: Get.find<OrderServices>()));

    await Get.putAsync(() async => OrdersState(orderServices: Get.find<OrderServices>()).init());

    Get.lazyPut<AllOrdersController>(
      () => AllOrdersController(ordersState: Get.find<OrdersState>()),
    );
  }
}
