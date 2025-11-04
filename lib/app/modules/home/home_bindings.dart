import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/service/auth_service.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import './home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        carrinhoServices: Get.find<CarrinhoServices>(),
        authService: Get.find<AuthService>(),
      ),
    );
  }
}
