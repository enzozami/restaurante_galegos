import 'package:get/get.dart';
import './lunchboxes_controller.dart';

class LunchboxesBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(LunchboxesController());
    }
}