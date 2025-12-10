import 'package:get/get.dart';
import './payment_controller.dart';

class PaymentBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(PaymentController());
    }
}