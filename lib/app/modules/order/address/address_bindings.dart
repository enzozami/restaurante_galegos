import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';
import './address_controller.dart';

class AddressBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddressController(cepServices: Get.find<CepServices>()));
  }
}
