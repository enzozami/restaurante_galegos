import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/core/service/food_service.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository.dart';
import 'package:restaurante_galegos/app/repositories/lunchboxes/lunchboxes_repository_impl.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services.dart';
import 'package:restaurante_galegos/app/services/lunchboxes/lunchboxes_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import './lunchboxes_controller.dart';

class LunchboxesBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LunchboxesRepository>(
      () => LunchboxesRepositoryImpl(
        restClient: Get.find<RestClient>(),
      ),
    );
    Get.lazyPut<LunchboxesServices>(
      () => LunchboxesServicesImpl(
        lunchboxesRepository: Get.find<LunchboxesRepository>(),
      ),
    );

    Get.putAsync(
      () => FoodService(
        lunchboxesServices: Get.find<LunchboxesServices>(),
      ).init(),
    );
    Get.lazyPut(
      () => LunchboxesController(
        lunchboxesServices: Get.find<LunchboxesServices>(),
        carrinhoServices: Get.find<CarrinhoServices>(),
        foodService: Get.find<FoodService>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}
