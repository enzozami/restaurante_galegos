import 'package:get/get_navigation/get_navigation.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/configuration_page.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_bindings.dart';

class DrawerRouters {
  DrawerRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/configuration',
      binding: GalegosDrawerBindings(),
      page: () => ConfigurationPage(),
    ),
  ];
}
