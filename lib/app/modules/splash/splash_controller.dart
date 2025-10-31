import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
    await checkLogged();
  }

  Future<void> checkLogged() async {
    await 1.seconds.delay();
    Get.putAsync(
      () {
        return AuthService().init();
      },
    );
  }
}
