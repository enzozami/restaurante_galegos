import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_card/shopping_card_page.dart';

class OrderRouters {
  OrderRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/order/shopping',
      binding: ShoppingCardBindings(),
      page: () => ShoppingCardPage(),
    )
  ];
}
