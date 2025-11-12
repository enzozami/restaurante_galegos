import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services_impl.dart';
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

    Get.lazyPut<CepRepository>(
      () => CepRepositoryImpl(
        viaCepService: Get.find<ViaCepService>(),
        restClient: Get.find<RestClient>(),
      ),
    );

    Get.lazyPut<CepServices>(
      () => CepServicesImpl(cepRepository: Get.find<CepRepository>()),
    );

    Get.put(
      ShoppingCardController(
        authService: Get.find<AuthService>(),
        orderServices: Get.find<OrderServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        cepServices: Get.find<CepServices>(),
        ordersState: Get.find<OrdersState>(),
      ),
    );
  }
}
