import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/history/history_controller.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import './finish_order_controller.dart';

class FinishOrderBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl());
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()),
    );
    Get.put(
      FinishOrderController(
        authServices: Get.find<AuthServices>(),
        orderServices: Get.find<OrderServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
      ),
    );
    Get.lazyPut(
      () => HistoryController(
        authServices: Get.find<AuthServices>(),
        ordersState: Get.find<OrderServices>(),
      ),
    );
  }
}
