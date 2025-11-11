import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/food_service.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/core/service/products_service.dart';
import 'package:restaurante_galegos/app/modules/history/history_controller.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_controller.dart';
import 'package:restaurante_galegos/app/modules/order/all_orders/all_orders_controller.dart';
import 'package:restaurante_galegos/app/modules/order/for_delivery/for_delivery_controller.dart';
import 'package:restaurante_galegos/app/modules/order/order_finished/order_finished_controller.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_controller.dart';
import 'package:restaurante_galegos/app/modules/products/products_controller.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/finished/order_finished_repository.dart';
import 'package:restaurante_galegos/app/repositories/finished/order_finished_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/items/items_repository.dart';
import 'package:restaurante_galegos/app/repositories/items/items_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository_impl.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services_impl.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services_impl.dart';
import 'package:restaurante_galegos/app/services/items/items_services.dart';
import 'package:restaurante_galegos/app/services/items/items_services_impl.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services_impl.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import './home_controller.dart';

class HomeBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut<ItemsRepository>(() => ItemsRepositoryImpl(restClient: Get.find<RestClient>()));
    Get.lazyPut<ItemsServices>(
      () => ItemsServicesImpl(
          itemsRepository: Get.find<ItemsRepository>(),
          productsRepository: Get.find<ProductsRepository>()),
    );
    Get.lazyPut<ProductsRepository>(
        () => ProductsRepositoryImpl(restClient: Get.find<RestClient>()));
    Get.lazyPut<ProductsServices>(
      () => ProductsServicesImpl(
        productsRepository: Get.find<ProductsRepository>(),
      ),
    );

    Get.lazyPut<LunchboxesRepository>(
        () => LunchboxesRepositoryImpl(restClient: Get.find<RestClient>()));
    Get.lazyPut<LunchboxesServices>(
        () => LunchboxesServicesImpl(lunchboxesRepository: Get.find<LunchboxesRepository>()));
    Get.lazyPut(
      () => LunchboxesController(
        lunchboxesServices: Get.find<LunchboxesServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        foodService: Get.find<FoodService>(),
        authService: Get.find<AuthService>(),
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

    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl(restClient: Get.find<RestClient>()));
    Get.lazyPut<OrderServices>(
        () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()));
    Get.lazyPut(
      () => ShoppingCardController(
        orderServices: Get.find<OrderServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        authService: Get.find<AuthService>(),
        cepServices: Get.find<CepServices>(),
      ),
    );

    Get.lazyPut<OrderFinishedRepository>(
      () => OrderFinishedRepositoryImpl(
        restClient: Get.find<RestClient>(),
      ),
    );
    Get.lazyPut<OrderFinishedServices>(
      () => OrderFinishedServicesImpl(
        orderFinishedRepository: Get.find<OrderFinishedRepository>(),
      ),
    );

    Get.lazyPut(
      () => AllOrdersController(
        orderFinishedServices: Get.find<OrderFinishedServices>(),
        ordersState: Get.find<OrdersState>(),
      ),
    );
    Get.lazyPut(
      () => ForDeliveryController(
        orderFinishedServices: Get.find<OrderFinishedServices>(),
        ordersState: Get.find<OrdersState>(),
      ),
    );

    Get.lazyPut(
      () => OrderFinishedController(
        ordersState: Get.find<OrdersState>(),
      ),
    );

    Get.lazyPut(
      () => OrdersState(
        orderServices: Get.find<OrderServices>(),
      ),
    );
    Get.lazyPut(
      () => ProductsService(
        itemsServices: Get.find<ItemsServices>(),
      ),
    );

    Get.lazyPut(
      () => FoodService(
        lunchboxesServices: Get.find<LunchboxesServices>(),
      ),
    );

    Get.lazyPut(
      () => ProductsController(
        productsServices: Get.find<ProductsServices>(),
        authService: Get.find<AuthService>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        productsService: Get.find<ProductsService>(),
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
