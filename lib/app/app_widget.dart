import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:restaurante_galegos/app/routes/splash_routers.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurante Galegos',
      getPages: [
        ...SplashRouters.routers,
      ],
    );
  }
}
