import 'package:get/get.dart';
import './order_controller.dart';

class OrderBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(OrderController());
    }
}