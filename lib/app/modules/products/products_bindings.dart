import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/products_service.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import './products_controller.dart';

class ProductsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      () => ProductsService(
        itemsServices: Get.find<ProductsServices>(),
      ),
    );
    Get.lazyPut(
      () => ProductsController(
        authService: Get.find<AuthService>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        productsService: Get.find<ProductsService>(),
      ),
      fenix: true,
    );
  }
}
