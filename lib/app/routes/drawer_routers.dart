import 'package:get/get_navigation/get_navigation.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/about_us/about_us_page.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/profile/profile_page.dart';
import 'package:restaurante_galegos/app/modules/drawer_pages/galegos_drawer_bindings.dart';

class DrawerRouters {
  DrawerRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/profile',
      binding: GalegosDrawerBindings(),
      page: () => ProfilePage(),
    ),
    GetPage(
      name: '/about_us',
      binding: GalegosDrawerBindings(),
      page: () => AboutUsPage(),
    )
  ];
}
