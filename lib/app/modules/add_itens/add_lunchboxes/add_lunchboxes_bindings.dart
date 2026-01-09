import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import './add_lunchboxes_controller.dart';

class AddLunchboxesBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddLunchboxesController(lunchboxesServices: Get.find<LunchboxesServices>()));
  }
}
