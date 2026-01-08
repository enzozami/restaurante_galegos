import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/add_itens/add_lunchboxes/add_lunchboxes_bindings.dart';
import 'package:restaurante_galegos/app/modules/add_itens/add_lunchboxes/add_lunchboxes_page.dart';
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
    GetPage(
      name: '/admin/lunchboxes',
      binding: AddLunchboxesBindings(),
      page: () => AddLunchboxesPage(),
    ),
  ];
}
