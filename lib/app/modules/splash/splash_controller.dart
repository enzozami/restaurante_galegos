import 'package:get/get.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services_impl.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
    await checkLogged();
  }

  Future<void> checkLogged() async {
    await 2.seconds.delay();
    Get.putAsync(() {
      return AuthServicesImpl(authRepository: Get.find<AuthRepository>()).init();
    });
  }
}
