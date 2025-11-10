import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/rest_client/rest_client.dart';
import 'package:restaurante_galegos/app/core/service/orders_state.dart';
import 'package:restaurante_galegos/app/repositories/finished/order_finished_repository.dart';
import 'package:restaurante_galegos/app/repositories/finished/order_finished_repository_impl.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty.dart';
import 'package:restaurante_galegos/app/repositories/order/order_reposiroty_impl.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services.dart';
import 'package:restaurante_galegos/app/services/finished/order_finished_services_impl.dart';
import 'package:restaurante_galegos/app/services/items/items_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services.dart';
import 'package:restaurante_galegos/app/services/order/order_services_impl.dart';
import './all_orders_controller.dart';

class AllOrdersBindings implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut<OrderReposiroty>(
      () => OrderReposirotyImpl(
        restClient: Get.find<RestClient>(),
      ),
    );
    Get.lazyPut<OrderServices>(
      () => OrderServicesImpl(
        orderRepository: Get.find<OrderReposiroty>(),
      ),
    );

    Get.lazyPut<OrderFinishedRepository>(
      () => OrderFinishedRepositoryImpl(
        restClient: Get.find<RestClient>(),
      ),
    );
    Get.lazyPut<OrderFinishedServices>(
      () => OrderFinishedServicesImpl(
        orderFinishedRepository: Get.find<OrderFinishedRepository>(),
      ),
    );

    await Get.putAsync(() async => OrdersState(
          orderServices: Get.find<OrderServices>(),
          itemsServices: Get.find<ItemsServices>(),
        ).init());

    Get.put(
      AllOrdersController(
        orderFinishedServices: Get.find<OrderFinishedServices>(),
        ordersState: Get.find<OrdersState>(),
      ),
    );
  }
}
