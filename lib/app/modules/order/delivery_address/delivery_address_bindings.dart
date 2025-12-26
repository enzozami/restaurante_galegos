import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository.dart';
import 'package:restaurante_galegos/app/repositories/cep/cep_repository_impl.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services.dart';
import 'package:restaurante_galegos/app/services/cep/cep_services_impl.dart';
import 'delivery_address_controller.dart';

class DeliveryAddressBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CepRepository>(() => CepRepositoryImpl(viaCepService: Get.find<ViaCepService>()));
    Get.lazyPut<CepServices>(() => CepServicesImpl(cepRepository: Get.find<CepRepository>()));

    Get.put(DeliveryAddressController(cepServices: Get.find<CepServices>()));
  }
}
