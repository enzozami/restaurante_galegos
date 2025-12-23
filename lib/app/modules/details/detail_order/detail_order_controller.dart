import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

class DetailOrderController extends GetxController {
  final PedidoModel order = Get.arguments;

  int getStepIndex() {
    switch (order.status) {
      case 'preparando':
        return 0;
      case 'a caminho':
        return 1;
      case 'entregue':
        return 3;
      default:
        return 0;
    }
  }
}
