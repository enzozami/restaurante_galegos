import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class GalegosAppBar extends AppBar {
  GalegosAppBar({super.key, Widget? icon})
    : super(
        elevation: GalegosUiDefaut.theme.appBarTheme.elevation,
        scrolledUnderElevation: GalegosUiDefaut.theme.appBarTheme.scrolledUnderElevation,
        backgroundColor: GalegosUiDefaut.theme.appBarTheme.backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        foregroundColor: GalegosUiDefaut.theme.appBarTheme.foregroundColor,
        iconTheme: GalegosUiDefaut.theme.appBarTheme.iconTheme,
        centerTitle: true,
        toolbarHeight: kToolbarHeight + 20,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.asset('assets/splash/splash_logo_dark.png', width: 90),
        ),
        actions: [icon ?? SizedBox.shrink()],
      );
}
