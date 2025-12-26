import 'package:get/get.dart';

import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
import 'package:restaurante_galegos/app/modules/history/history_controller.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';
import 'package:restaurante_galegos/app/modules/order/all_orders/all_orders_controller.dart';
import 'package:restaurante_galegos/app/modules/order/for_delivery/for_delivery_controller.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_controller.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_controller.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services_impl.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services_impl.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services_impl.dart';

import './home_controller.dart';

class HomeBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    // Repositories
    Get.lazyPut<TimeRepository>(() => TimeRepositoryImpl());
    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl());
    Get.lazyPut<LunchboxesRepository>(() => LunchboxesRepositoryImpl());
    Get.lazyPut<ProductsRepository>(() => ProductsRepositoryImpl());
    Get.lazyPut<CepRepository>(
      () => CepRepositoryImpl(viaCepService: Get.find<ViaCepService>()),
    );

    // Services
    Get.lazyPut(() => CarrinhoServices(), fenix: true);
    Get.lazyPut(() => ViaCepService(), fenix: true);
    Get.lazyPut<TimeServices>(
      () => TimeServicesImpl(timeRepository: Get.find<TimeRepository>()),
    );
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()),
    );
    Get.lazyPut<LunchboxesServices>(
      () => LunchboxesServicesImpl(
        lunchboxesRepository: Get.find<LunchboxesRepository>(),
        timeServices: Get.find<TimeServices>(),
      ),
    );
    Get.lazyPut<ProductsServices>(
      () => ProductsServicesImpl(
        productsRepository: Get.find<ProductsRepository>(),
      ),
    );
    Get.lazyPut<ProductsServices>(
      () => ProductsServicesImpl(
        productsRepository: Get.find<ProductsRepository>(),
      ),
    );
    Get.lazyPut<CepServices>(
      () => CepServicesImpl(cepRepository: Get.find<CepRepository>()),
    );

    // Controllers
    Get.lazyPut(
      () => ProductsController(
        authService: Get.find<AuthServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        productsServices: Get.find<ProductsServices>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => LunchboxesController(
        lunchboxesServices: Get.find<LunchboxesServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        foodService: Get.find<LunchboxesServices>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
    Get.lazyPut(
      () => AllOrdersController(
        ordersState: Get.find<OrderServices>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
    Get.lazyPut(
      () => ForDeliveryController(
        ordersState: Get.find<OrderServices>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
    Get.lazyPut(
      () => ShoppingCardController(
        carrinhoServices: Get.find<CarrinhoServices>(),
      ),
    );
    Get.lazyPut(() => OrderFinishedController());
    Get.lazyPut<HistoryController>(
      () => HistoryController(
        authServices: Get.find<AuthServices>(),
        ordersState: Get.find<OrderServices>(),
      ),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
        carrinhoServices: Get.find<CarrinhoServices>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
  }
}
