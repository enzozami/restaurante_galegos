import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class GalegosAppBar extends AppBar {
  GalegosAppBar({super.key, Widget? icon})
      : super(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: GalegosUiDefaut.theme.appBarTheme.backgroundColor,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.network(
              'https://restaurantegalegos.wabiz.delivery/stores/restaurantegalegos/img/homeLogo.png?vc=20250915111500&cvc=',
              width: 100,
            ),
          ),
          actions: [icon ?? SizedBox.shrink()],
        );
}
