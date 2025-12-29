import 'package:get/get.dart';
import './welcome_controller.dart';

class WelcomeBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(WelcomeController());
    }
}