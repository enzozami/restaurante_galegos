import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/products/products_services.dart';
import './detail_product_controller.dart';

class DetailProductBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DetailProductController(productsServices: Get.find<ProductsServices>()));
  }
}
