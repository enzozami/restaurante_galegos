import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository.dart';
import 'package:restaurante_galegos/app/repositories/time/time_repository_impl.dart';
import 'package:restaurante_galegos/app/services/time/time_services.dart';
import 'package:restaurante_galegos/app/services/time/time_services_impl.dart';
import './time_controller.dart';

class TimeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeRepository>(() => TimeRepositoryImpl());
    Get.lazyPut<TimeServices>(() => TimeServicesImpl(timeRepository: Get.find<TimeRepository>()));
    Get.put(TimeController(timeServices: Get.find<TimeServices>()));
  }
}
