import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/drinks/drinks_bindings.dart';
import 'package:restaurante_galegos/app/modules/drinks/drinks_page.dart';

class DrinksRouters {
  DrinksRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/drinks',
      binding: DrinksBindings(),
      page: () => DrinksPage(),
    )
  ];
}
