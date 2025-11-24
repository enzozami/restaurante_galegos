import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

class ForDeliveryController extends GetxController with LoaderMixin, MessagesMixin {
  final OrdersState _ordersState;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final status = Rxn<String>(Get.arguments);

  ForDeliveryController({required OrdersState ordersState}) : _ordersState = ordersState;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  RxList<PedidoModel> get listOrders =>
      _ordersState.all.where((e) => e.status == 'a caminho').toList().obs;

  // void orderFinished(PedidoModel pedido) async {
  //   final newTime = FormatterHelper.formatDateAndTime();

  //   await _orderFinishedServices.orderFinished(
  //     pedido.copyWith(status: 'entregue', timeFinished: newTime),
  //   );
  //   _orderFinishedServices.changeStatusFinished(pedido.copyWith(timeFinished: newTime));
  //   _ordersState.update(pedido, 'entregue');
  // }
}
