import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/shopping_card/shopping_card_bindings.dart';
import 'package:restaurante_galegos/app/modules/shopping_card/shopping_card_page.dart';

class ShoppginCardRouters {
  ShoppginCardRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/shopping_card',
      binding: ShoppingCardBindings(),
      page: () => ShoppingCardPage(),
    ),
  ];
}
