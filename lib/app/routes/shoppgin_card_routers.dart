import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_cart/shopping_cart_bindings.dart';
import 'package:restaurante_galegos/app/modules/order/shopping_cart/shopping_cart_page.dart';

class ShoppginCartRouters {
  ShoppginCartRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/shopping_card',
      binding: ShoppingCartBindings(),
      page: () => ShoppingCartPage(),
    ),
  ];
}
