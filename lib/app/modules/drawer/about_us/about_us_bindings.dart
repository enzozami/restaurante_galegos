import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/about_us/about_us_repository.dart';
import 'package:restaurante_galegos/app/repositories/about_us/about_us_repository_impl.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services.dart';
import 'package:restaurante_galegos/app/services/about_us/about_us_services_impl.dart';
import './about_us_controller.dart';

class AboutUsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutUsRepository>(() => AboutUsRepositoryImpl());
    Get.lazyPut<AboutUsServices>(
      () => AboutUsServicesImpl(aboutUsRepository: Get.find<AboutUsRepository>()),
    );
    Get.put(AboutUsController(aboutUsServices: Get.find<AboutUsServices>()));
  }
}
