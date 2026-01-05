import 'package:get/get.dart';
import 'package:restaurante_galegos/app/modules/splash/splash_page.dart';

class SplashRouters {
  SplashRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/splash',
      page: () => SplashPage(),
    ),
  ];
}
