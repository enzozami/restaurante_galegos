import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';

class SplashController extends GetxController {
  void checkLogged() {
    Get.putAsync(() => AuthService().init(), permanent: true);
  }
}
