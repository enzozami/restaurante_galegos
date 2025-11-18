import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class GalegosAppBar extends AppBar {
  GalegosAppBar({super.key, Widget? icon})
      : super(
          elevation: GalegosUiDefaut.theme.appBarTheme.elevation,
          scrolledUnderElevation: GalegosUiDefaut.theme.appBarTheme.scrolledUnderElevation,
          backgroundColor: GalegosUiDefaut.theme.appBarTheme.backgroundColor,
          foregroundColor: GalegosUiDefaut.theme.appBarTheme.foregroundColor,
          iconTheme: GalegosUiDefaut.theme.appBarTheme.iconTheme,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.network(
              'https://restaurantegalegos.wabiz.delivery/stores/restaurantegalegos/img/homeLogo.png?vc=20250915111500&cvc=',
              width: 80,
            ),
          ),
          actions: [icon ?? SizedBox.shrink()],
        );
}
