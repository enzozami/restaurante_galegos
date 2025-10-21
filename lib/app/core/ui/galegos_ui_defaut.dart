import 'package:flutter/material.dart';

class GalegosUiDefaut {
  GalegosUiDefaut._();

  static final ThemeData theme = ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
    ),
    primaryColorDark: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
      ),
    ),
  );
}
