import 'package:get/get.dart';
import './order_finished_controller.dart';

class OrderFinishedBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(OrderFinishedController());
    }
}