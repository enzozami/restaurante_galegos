import 'package:get/get.dart';
import './add_products_controller.dart';

class AddProductsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddProductsController());
  }
}
