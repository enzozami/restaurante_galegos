import 'package:get/get.dart';
import './shopping_card_controller.dart';

class ShoppingCardBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ShoppingCardController());
    }
}