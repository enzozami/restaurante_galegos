import 'package:get/get.dart';
import 'package:restaurante_galegos/app/services/shopping/carrinho_services.dart';
import 'detail_lunchboxes_controller.dart';

class DetailLunchboxesBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DetailLunchboxesController(carrinhoServices: Get.find<CarrinhoServices>()));
  }
}
