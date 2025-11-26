import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/food_service.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/modules/history/history_controller.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';
import 'package:restaurante_galegos/app/modules/order/all_orders/all_orders_controller.dart';
import 'package:restaurante_galegos/app/modules/order/for_delivery/for_delivery_controller.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_controller.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_controller.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository_impl.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services_impl.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services_impl.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services_impl.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services_impl.dart';
import './home_controller.dart';

class HomeBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut<ProductsRepository>(() => ProductsRepositoryImpl());
    Get.lazyPut<ProductsServices>(
      () => ProductsServicesImpl(productsRepository: Get.find<ProductsRepository>()),
    );

    Get.lazyPut(() => AllOrdersController(ordersState: Get.find<OrdersState>()));
    Get.lazyPut(() => ForDeliveryController(ordersState: Get.find<OrdersState>()));

    Get.lazyPut<LunchboxesRepository>(() => LunchboxesRepositoryImpl());
    Get.lazyPut<LunchboxesServices>(
      () => LunchboxesServicesImpl(lunchboxesRepository: Get.find<LunchboxesRepository>()),
    );
    Get.lazyPut(
      () => LunchboxesController(
        lunchboxesServices: Get.find<LunchboxesServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        foodService: Get.find<FoodService>(),
        authService: Get.find<AuthService>(),
      ),
    );

    Get.lazyPut<CepRepository>(() => CepRepositoryImpl(viaCepService: Get.find<ViaCepService>()));
    Get.lazyPut<CepServices>(() => CepServicesImpl(cepRepository: Get.find<CepRepository>()));

    Get.lazyPut<TimeRepository>(() => TimeRepositoryImpl());
    Get.lazyPut<TimeServices>(() => TimeServicesImpl(timeRepository: Get.find<TimeRepository>()));

    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl());
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()),
    );
    Get.lazyPut(
      () => ShoppingCardController(
        orderServices: Get.find<OrderServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        authService: Get.find<AuthService>(),
        cepServices: Get.find<CepServices>(),
        ordersState: Get.find<OrdersState>(),
      ),
    );

    Get.lazyPut(() => OrderFinishedController());

    Get.lazyPut(() => OrdersState(orderServices: Get.find<OrderServices>()));
    Get.lazyPut<ProductsRepository>(() => ProductsRepositoryImpl());
    Get.lazyPut(() => ProductsServicesImpl(productsRepository: Get.find<ProductsRepository>()));

    Get.lazyPut(
      () => FoodService(
        lunchboxesServices: Get.find<LunchboxesServices>(),
        timeServices: Get.find<TimeServices>(),
      ),
    );

    Get.lazyPut(
      () => ProductsController(
        authService: Get.find<AuthService>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        productsServices: Get.find<ProductsServices>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => HistoryController(
        authService: Get.find<AuthService>(),
        ordersState: Get.find<OrdersState>(),
      ),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(
        carrinhoServices: Get.find<CarrinhoServices>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}
