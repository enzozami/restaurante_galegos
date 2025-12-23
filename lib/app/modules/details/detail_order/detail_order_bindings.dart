import 'package:get/get.dart';
import 'detail_order_controller.dart';

class DetailOrderBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DetailOrderController());
  }
}
