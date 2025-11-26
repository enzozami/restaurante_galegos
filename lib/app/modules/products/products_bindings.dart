import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import './products_controller.dart';

class ProductsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProductsController(
        authService: Get.find<AuthServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        productsServices: Get.find<ProductsServices>(),
      ),
      fenix: true,
    );
  }
}
