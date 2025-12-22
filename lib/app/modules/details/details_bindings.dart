import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import './details_controller.dart';

class DetailsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DetailsController(carrinhoServices: Get.find<CarrinhoServices>()));
  }
}
