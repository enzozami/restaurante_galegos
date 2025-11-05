import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/mixins/loader_mixin.dart';
import 'package:restaurante_galegos/app/core/mixins/messages_mixin.dart';
import 'package:restaurante_galegos/app/models/order_finished_model.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';

class OrderFinishedController extends GetxController with LoaderMixin, MessagesMixin {
  final OrderFinishedServices _orderFinishedServices;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  OrderFinishedController({
    required OrderFinishedServices orderFinishedServices,
  }) : _orderFinishedServices = orderFinishedServices;

  final _listOriginalOrder = <OrderFinishedModel>[].obs;
  final listOrder = <OrderFinishedModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  void onReady() {
    super.onReady();
    _loadAllOrdersOnFinished();
  }

  void _loadAllOrdersOnFinished() async {
    _loading(true);
    final orderListData = await _orderFinishedServices.getOrderFinished();
    listOrder.assignAll(orderListData);
    _listOriginalOrder
      ..clear()
      ..addAll(orderListData);

    _loading(false);
  }
}
