import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services_impl.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services_impl.dart';

class GalegosBindings implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => RestClient(), fenix: true);
    Get.lazyPut<TimeRepository>(() => TimeRepositoryImpl(), fenix: true);
    Get.lazyPut<TimeServices>(
      () => TimeServicesImpl(timeRepository: Get.find<TimeRepository>()),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.putAsync<AuthServices>(
      () async => AuthServicesImpl(authRepository: Get.find<AuthRepository>()),
    );
  }
}
