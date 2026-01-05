import 'package:flutter/material.dart';

class AppColors {
  static final Color primary = Color(0xFFE2943b);
  static final Color secondary = Color(0xFFe8bb87);
  static final Color tertiary = Color(0xFF3D271E);
  static final Color title = Color(0xFF734511);
  static final Color text = Color(0xFFA25F13);
  static final Color error = Colors.red.shade700;
  static final Color background = Color(0xFFFFFAF5);
  static final Color preparing = Color(0xFF6290F3);
  static final Color containerPreparing = Color(0xFFDDE7FD);
  static final Color onTheWay = Color(0xFFE2943b);
  static final Color containerOnTheWay = Color(0xFFFFEAD3);
  static final Color delivered = Color(0xFF3CA41A);
  static final Color containerDelivered = Color(0xFFD9FFCC);

  static final ColorScheme mainColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Color(0xFF442400),
    secondary: secondary,
    onSecondary: Color(0xFF000000),
    tertiary: tertiary,
    onTertiary: Color(0xFFFFFFFF),
    error: Colors.red.shade700,
    onError: Colors.white,
    surface: background,
    onSurface: Color(0xFF3D3028),
  );
}
