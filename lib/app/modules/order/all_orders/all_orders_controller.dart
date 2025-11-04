import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/pedido_model.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';

class AllOrdersController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderServices _orderServices;
  final OrderFinishedServices _orderFinishedServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  AllOrdersController({
    required OrderServices orderServices,
    required OrderFinishedServices orderFinishedServices,
  })  : _orderServices = orderServices,
        _orderFinishedServices = orderFinishedServices;

  final _ordersOriginal = <PedidoModel>[].obs;
  final listOrders = <PedidoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    _loadAllOrders();
  }

  void _loadAllOrders() async {
    try {
      _loading(true);
      final orderListOriginal = await _orderServices.getOrder();
      final filtered = orderListOriginal.where((e) => e.status != 'finalizado').toList();
      listOrders.assignAll(filtered);
      _ordersOriginal
        ..clear()
        ..addAll(filtered);
    } catch (e) {
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao carregar pedidos',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading.value = false;
    }
  }

  void orderFinished(PedidoModel pedido) async {
    _loading(true);
    try {
      final listData = await _orderFinishedServices.orderFinished(
        pedido.copyWith(status: 'finalizado'),
      );
      await _orderFinishedServices.changeStatus(pedido);
      final newListOrders = _ordersOriginal
        ..clear()
        ..where((e) => e.status != listData.pedido.status).toList();
      listOrders.assignAll(newListOrders);
    } finally {
      _loading(false);
      _loadAllOrders();
    }
  }
}
