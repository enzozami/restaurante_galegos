import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/core/ui/formatter_helper.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';

class AllOrdersController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderFinishedServices _orderFinishedServices;
  final OrdersState _ordersState;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  AllOrdersController({
    required OrderFinishedServices orderFinishedServices,
    required OrdersState ordersState,
  })  : _orderFinishedServices = orderFinishedServices,
        _ordersState = ordersState;

  final newTime = FormatterHelper.formatDateAndTime();

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
    _ordersState.init();
  }

  RxList<PedidoModel> get listOrders =>
      _ordersState.all.where((e) => e.status == 'preparando').toList().obs;

  void orderFinished(PedidoModel pedido) async {
    await _orderFinishedServices.orderFinished(
      pedido.copyWith(status: 'a caminho', timePath: newTime),
    );
    _orderFinishedServices.changeStatusOnTheWay(pedido);
    _ordersState.update(pedido, 'a caminho');
  }
}
