import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';

class OrderFinishedController extends GetxController with LoaderMixin, MessagesMixin {
  final OrdersState _ordersState;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  OrderFinishedController({
    required OrdersState ordersState,
  }) : _ordersState = ordersState;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  RxList<PedidoModel> get listOrder =>
      _ordersState.all.where((e) => e.status == 'entregue').toList().obs;
}
