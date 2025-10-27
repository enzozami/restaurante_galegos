import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import 'shopping_card_controller.dart';

class ShoppingCardBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderReposiroty>(
      () => OrderReposirotyImpl(
        restClient: Get.find<RestClient>(),
      ),
    );
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(
        orderRepository: Get.find<OrderReposiroty>(),
      ),
    );
    Get.put(
      ShoppingCardController(
        authService: Get.find<AuthService>(),
        orderServices: Get.find<OrderServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
      ),
    );
  }
}
