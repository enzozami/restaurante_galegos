import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/repositories/items/items_repository.dart';
import 'package:restaurante_galegos/app/repositories/items/items_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository.dart';
import 'package:restaurante_galegos/app/repositories/products/products_repository_impl.dart';
import 'package:restaurante_galegos/app/services/items/items_services.dart';
import 'package:restaurante_galegos/app/services/items/items_services_impl.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
//import 'package:restaurante_galegos/app/services/shopping/shopping_services.dart';
import './products_controller.dart';

class ProductsBindings implements Bindings {
  @override
  void dependencies() {
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

    Get.lazyPut(
      () => ProductsController(
        productsServices: Get.find<ProductsServices>(),
        authService: Get.find<AuthService>(),
        itemsServices: Get.find<ItemsServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        ordersState: Get.find<OrdersState>(),
      ),
      fenix: true,
    );
  }
}
