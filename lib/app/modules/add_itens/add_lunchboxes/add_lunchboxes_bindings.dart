import 'package:get/get.dart';
import './add_lunchboxes_controller.dart';

class AddLunchboxesBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddLunchboxesController());
  }
}
