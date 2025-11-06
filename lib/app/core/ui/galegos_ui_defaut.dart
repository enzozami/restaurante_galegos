import 'package:flutter/material.dart';

class GalegosUiDefaut {
  GalegosUiDefaut._();

  static final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFE2933C),
    onPrimary: Colors.black,
    secondary: Color(0xFFFFFAF5),
    onSecondary: Colors.black,
    tertiary: const Color(0xFFFFFFFF),
    onTertiary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    surface: Color(0xFFFFFAF5),
    onSurface: Colors.black,
  );

  static final ThemeData theme = ThemeData(
    primaryColor: Colors.white,
    colorScheme: colorScheme,
    cardTheme: CardThemeData(
      color: Color(0xFFFFFFFF),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
    splashColor: Color(0xFFE2933C),
    scaffoldBackgroundColor: Colors.white,
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFFFEBD6),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    primaryColorDark: Colors.black,
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: const Color.fromARGB(30, 0, 0, 0),
      backgroundColor: const Color(0xFFE2933C),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: const Color(0xFFE2933C),
        iconColor: Color(0xffE2933C),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFE2933C),
      ),
    ),
  );
}
