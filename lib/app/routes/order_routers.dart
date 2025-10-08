import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/order/order_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/order_page.dart';

class OrderRouters {
  OrderRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/order',
      binding: OrderBindings(),
      page: () => OrderPage(),
    )
  ];
}
