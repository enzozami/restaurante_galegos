import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_bindings.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/lunchboxes_page.dart';
import 'package:restaurante_galegos/app/modules/lunchboxes/widgets/foods_details.dart';

class LunchboxesRouters {
  LunchboxesRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/lunchboxes',
      binding: LunchboxesBindings(),
      page: () => LunchboxesPage(),
    ),
    GetPage(
      name: '/lunchboxes/detail',
      binding: LunchboxesBindings(),
      page: () => FoodsDetails(),
    ),
  ];
}
