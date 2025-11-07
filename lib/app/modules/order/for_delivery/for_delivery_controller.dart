import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';

class ForDeliveryController extends GetxController with LoaderMixin, MessagesMixin {
  final OrdersState _ordersState;
  final OrderFinishedServices _orderFinishedServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  final status = Rxn<String>(Get.arguments);

  ForDeliveryController({
    required OrderFinishedServices orderFinishedServices,
    required OrdersState ordersState,
  })  : _ordersState = ordersState,
        _orderFinishedServices = orderFinishedServices;

  final newTime = FormatterHelper.formatDateAndTime();

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  RxList<PedidoModel> get listOrders =>
      _ordersState.all.where((e) => e.status == 'a caminho').toList().obs;

  void orderFinished(PedidoModel pedido) async {
    await _orderFinishedServices.orderFinished(
      pedido.copyWith(status: 'entregue', timeFinished: newTime),
    );
    _orderFinishedServices.changeStatusFinished(pedido);
    _ordersState.update(pedido, 'entregue');
  }
}
