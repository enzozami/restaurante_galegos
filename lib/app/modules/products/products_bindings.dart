import 'package:get/get.dart';
import './products_controller.dart';

class ProductsBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ProductsController());
    }
}