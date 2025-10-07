import 'package:get/route_manager.dart';
import 'package:restaurante_galegos/app/modules/home/home_bindings.dart';
import 'package:restaurante_galegos/app/modules/home/home_page.dart';

class HomeRouters {
  HomeRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/home',
      binding: HomeBindings(),
      page: () => HomePage(),
    ),
  ];
}
