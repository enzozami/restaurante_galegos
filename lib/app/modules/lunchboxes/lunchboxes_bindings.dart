import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/food_service.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';
import './lunchboxes_controller.dart';

class LunchboxesBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LunchboxesRepository>(() => LunchboxesRepositoryImpl());
    Get.lazyPut<LunchboxesServices>(
      () => LunchboxesServicesImpl(lunchboxesRepository: Get.find<LunchboxesRepository>()),
    );

    Get.putAsync(
      () => FoodService(
        lunchboxesServices: Get.find<LunchboxesServices>(),
        timeServices: Get.find<TimeServices>(),
      ).init(),
    );
    Get.lazyPut(
      () => LunchboxesController(
        lunchboxesServices: Get.find<LunchboxesServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        foodService: Get.find<FoodService>(),
        authServices: Get.find<AuthServices>(),
      ),
    );
  }
}
