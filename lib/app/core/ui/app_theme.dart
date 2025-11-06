import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class AppTheme {
  AppTheme({required this.colorScheme});
  final ColorScheme colorScheme;

  static ThemeData galegosUiDefault() {
    return AppTheme(colorScheme: GalegosUiDefaut.colorScheme).themeData;
  }

  ThemeData get themeData => ThemeData(
        colorScheme: colorScheme,
      );
}
