import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';
import 'package:restaurante_galegos/app/repositories/user/user_repository.dart';
import 'package:restaurante_galegos/app/repositories/user/user_repository_impl.dart';
import 'package:restaurante_galegos/app/services/user/user_services.dart';
import 'package:restaurante_galegos/app/services/user/user_services_impl.dart';

class GalegosDrawerBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(
        restClient: Get.find<RestClient>(),
      ),
    );
    Get.lazyPut<UserServices>(
      () => UserServicesImpl(
        userRepository: Get.find<UserRepository>(),
      ),
    );
    Get.put(
      GalegosDrawerController(
        userServices: Get.find<UserServices>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}
