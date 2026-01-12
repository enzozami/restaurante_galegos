import 'package:get/get_navigation/get_navigation.dart';
import 'package:restaurante_galegos/app/modules/drawer/about_us/about_us_bindings.dart';
import 'package:restaurante_galegos/app/modules/drawer/about_us/about_us_page.dart';
import 'package:restaurante_galegos/app/modules/drawer/profile/profile_bindings.dart';
import 'package:restaurante_galegos/app/modules/drawer/profile/profile_page.dart';
import 'package:restaurante_galegos/app/modules/drawer/horario_funcionamento/horario_funcionamento_bindings.dart';
import 'package:restaurante_galegos/app/modules/drawer/horario_funcionamento/horario_funcionamento_page.dart';

class DrawerRouters {
  DrawerRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/profile',
      binding: ProfileBindings(),
      page: () => ProfilePage(),
    ),
    GetPage(
      name: '/about_us',
      binding: AboutUsBindings(),
      page: () => AboutUsPage(),
    ),
    GetPage(
      name: '/horario_funcionamento',
      binding: HorarioFuncionamentoBindings(),
      page: () => HorarioFuncionamentoPage(),
    ),
  ];
}
