import 'package:flutter/material.dart';

class GalegosUiDefaut {
  GalegosUiDefaut._();

  static final ThemeData theme = ThemeData(
    primaryColor: Colors.white,
    bottomAppBarTheme: BottomAppBarThemeData(
      surfaceTintColor: Color(0xFFE2933C),
      color: Color(0xFFE2933C),
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
      backgroundColor: Colors.white,
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
