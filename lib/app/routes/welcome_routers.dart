import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/welcome/welcome_bindings.dart';
import 'package:restaurante_galegos/app/modules/welcome/welcome_page.dart';

class WelcomeRouters {
  WelcomeRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/',
      binding: WelcomeBindings(),
      page: () => WelcomePage(),
    ),
  ];
}
