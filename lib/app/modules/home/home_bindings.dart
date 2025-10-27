import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/shopping/shopping_card_services.dart';
import './home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShoppingCardServices());
    Get.lazyPut(() => HomeController());
  }
}
