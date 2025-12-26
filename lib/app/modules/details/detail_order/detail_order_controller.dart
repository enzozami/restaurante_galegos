import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/auth/auth_services.dart';

class DetailOrderController extends GetxController {
  final AuthServices _authServices;

  final PedidoModel order = Get.arguments;

  DetailOrderController({required AuthServices authServices}) : _authServices = authServices;

  bool get admin => _authServices.isAdmin();

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
