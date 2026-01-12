import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import './detail_lunchbox_adm_controller.dart';

class DetailLunchboxAdmBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DetailLunchboxAdmController(lunchboxesServices: Get.find<LunchboxesServices>()));
  }
}
