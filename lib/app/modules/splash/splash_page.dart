import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';
import './splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://restaurantegalegos.wabiz.delivery/stores/restaurantegalegos/img/homeLogo.png?vc=20250915111500&cvc=',
              width: Get.width,
              height: 300,
            ),
            const SizedBox(
              height: 10,
            ),
            GalegosButtonDefault(
              label: 'Acessar',
              onPressed: () => controller.checkLogged(),
            ),
          ],
        ),
      ),
    );
  }
}
