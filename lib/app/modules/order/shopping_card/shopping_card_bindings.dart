import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
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
    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl());
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()),
    );

    Get.lazyPut<CepRepository>(() => CepRepositoryImpl(viaCepService: Get.find<ViaCepService>()));

    Get.lazyPut<CepServices>(() => CepServicesImpl(cepRepository: Get.find<CepRepository>()));

    Get.put(
      ShoppingCardController(
        carrinhoServices: Get.find<CarrinhoServices>(),
      ),
    );
  }
}
