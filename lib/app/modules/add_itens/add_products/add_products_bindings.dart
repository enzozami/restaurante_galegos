import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import './add_products_controller.dart';

class AddProductsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddProductsController(productsServices: Get.find<ProductsServices>()));
  }
}
