import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/repositories/finished/order_finished_repository.dart';
import 'package:restaurante_galegos/app/repositories/finished/order_finished_repository_impl.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services_impl.dart';
import './order_finished_controller.dart';

class OrderFinishedBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderFinishedRepository>(
      () => OrderFinishedRepositoryImpl(
        restClient: Get.find<RestClient>(),
      ),
    );
    Get.lazyPut<OrderFinishedServices>(
      () => OrderFinishedServicesImpl(
        orderFinishedRepository: Get.find(),
      ),
    );
    Get.put(
      OrderFinishedController(
        ordersState: Get.find<OrdersState>(),
      ),
    );
  }
}
