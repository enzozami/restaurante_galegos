import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_bindings.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_page.dart';

class LunchboxesRouters {
  LunchboxesRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/lunchboxes',
      binding: LunchboxesBindings(),
      page: () => LunchboxesPage(),
    ),
  ];
}
