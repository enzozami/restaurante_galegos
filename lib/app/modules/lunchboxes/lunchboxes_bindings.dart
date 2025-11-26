import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';
import './lunchboxes_controller.dart';

class LunchboxesBindings implements Bindings {
  @override
  void dependencies() {
    Get.putAsync(
      () => LunchboxesServicesImpl(
        timeServices: Get.find<TimeServices>(),
        lunchboxesRepository: Get.find<LunchboxesRepository>(),
      ).init(),
    );
    Get.lazyPut(
      () => LunchboxesController(
        lunchboxesServices: Get.find<LunchboxesServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        foodService: Get.find<LunchboxesServices>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
  }
}
