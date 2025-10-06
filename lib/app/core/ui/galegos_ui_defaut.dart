import 'package:flutter/material.dart';

class GalegosUiDefaut {
  GalegosUiDefaut._();

  static final ThemeData theme = ThemeData(
    primaryColor: Colors.amber,
    primaryColorDark: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
      ),
    ),
  );
}
