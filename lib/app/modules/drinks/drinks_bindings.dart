import 'package:get/get.dart';
import './drinks_controller.dart';

class DrinksBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(DrinksController());
    }
}