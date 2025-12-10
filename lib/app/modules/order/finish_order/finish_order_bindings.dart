import 'package:get/get.dart';
import './finish_order_controller.dart';

class FinishOrderBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(FinishOrderController());
    }
}