import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/rest_client/via_cep_service.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository.dart';
import 'package:restaurante_galegos/app/repositories/auth/auth_repository_impl.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services_impl.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';

class GalegosBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RestClient(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<AuthServices>(
      () => AuthServicesImpl(authRepository: Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(() => CarrinhoServices(), fenix: true);
    Get.lazyPut(() => ViaCepService(), fenix: true);
  }
}
