import 'package:get/get.dart';
import './register_controller.dart';

class RegisterBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(RegisterController());
    }
}