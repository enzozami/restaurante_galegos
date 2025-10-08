import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:restaurante_galegos/app/core/bindings/galegos_bindings.dart';
import 'package:restaurante_galegos/app/routes/auth_routers.dart';
import 'package:restaurante_galegos/app/routes/drinks_routers.dart';
import 'package:restaurante_galegos/app/routes/home_routers.dart';
import 'package:restaurante_galegos/app/routes/order_routers.dart';
import 'package:restaurante_galegos/app/routes/products_routers.dart';
import 'package:restaurante_galegos/app/routes/shoppgin_card_routers.dart';
import 'package:restaurante_galegos/app/routes/splash_routers.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurante Galegos',
      initialRoute: '/',
      initialBinding: GalegosBindings(),
      getPages: [
        ...SplashRouters.routers,
        ...AuthRouters.routers,
        ...HomeRouters.routers,
        ...ProductsRouters.routers,
        ...OrderRouters.routers,
        ...DrinksRouters.routers,
        ...ShoppginCardRouters.routers,
      ],
    );
  }
}
