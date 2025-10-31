import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_controller.dart';
import 'package:restaurante_galegos/app/repositories/about_us/about_us_repository.dart';
import 'package:restaurante_galegos/app/repositories/about_us/about_us_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/user/user_repository.dart';
import 'package:restaurante_galegos/app/repositories/user/user_repository_impl.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services_impl.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services_impl.dart';
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

    Get.lazyPut<AboutUsRepository>(
      () => AboutUsRepositoryImpl(
        restClient: Get.find<RestClient>(),
      ),
    );
    Get.lazyPut<AboutUsServices>(
      () => AboutUsServicesImpl(
        aboutUsRepository: Get.find<AboutUsRepository>(),
      ),
    );

    Get.lazyPut<TimeRepository>(
      () => TimeRepositoryImpl(
        restClient: Get.find<RestClient>(),
      ),
    );

    Get.lazyPut<TimeServices>(
      () => TimeServicesImpl(
        timeRepository: Get.find<TimeRepository>(),
      ),
    );

    Get.lazyPut<OrderReposiroty>(() => OrderReposirotyImpl(restClient: Get.find<RestClient>()));
    Get.lazyPut<OrderServices>(
        () => OrderServicesImpl(orderRepository: Get.find<OrderReposiroty>()));

    Get.put(
      GalegosDrawerController(
        userServices: Get.find<UserServices>(),
        authService: Get.find<AuthService>(),
        aboutUsServices: Get.find<AboutUsServices>(),
        timeServices: Get.find<TimeServices>(),
        orderServices: Get.find<OrderServices>(),
      ),
    );
  }
}
