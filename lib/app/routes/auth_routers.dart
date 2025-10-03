import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:restaurante_galegos/app/modules/auth/login/login_bindings.dart';
import 'package:restaurante_galegos/app/modules/auth/login/login_page.dart';
import 'package:restaurante_galegos/app/modules/auth/register/register_bindings.dart';
import 'package:restaurante_galegos/app/modules/auth/register/register_page.dart';

class AuthRouters {
  AuthRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/auth/login',
      binding: LoginBindings(),
      page: () => LoginPage(),
    ),
    GetPage(
      name: '/auth/register',
      binding: RegisterBindings(),
      page: () => RegisterPage(),
    ),
  ];
}
