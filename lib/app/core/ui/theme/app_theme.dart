import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';

class AppTheme {
  AppTheme({required this.colorScheme});

  final ColorScheme colorScheme;

  static ThemeData theme() {
    return AppTheme(colorScheme: AppColors.mainColorScheme).themeData;
  }

  ThemeData get themeData => ThemeData(
    colorScheme: colorScheme,
    textTheme: textTheme,
    splashColor: colorScheme.tertiary,
    inputDecorationTheme: inputDecorationTheme,
    cardTheme: cardTheme,
    appBarTheme: appBarTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    textButtonTheme: textButtonData,
    floatingActionButtonTheme: floatingActionButtonThemeData,
    navigationBarTheme: navigationbarTheme,
  );

  TextTheme get textTheme => TextTheme(
    // TITULO DA PAGINA
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.normal,
      color: AppColors.title,
    ),
    // SUB TITULO
    headlineMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.normal,
      color: AppColors.title,
    ),
    // TITULO CURTISSIMO
    headlineSmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: AppColors.title,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 22,
      color: AppColors.title,
      fontWeight: FontWeight.normal,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 20,
      color: AppColors.title,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: AppColors.title,
    ),
    // TEXTO - PARAGRAFO
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
    ),
    // TEXTO - LEGENDA/TEXTO DE APOIO
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
    ),
    // TEXTO - BOTÃO
    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      color: AppColors.text,
      fontWeight: FontWeight.normal,
    ),
    // TEXTO - PARA COMPOS DE ENTRADA
    labelMedium: GoogleFonts.poppins(
      fontSize: 12,
      color: AppColors.text,
      fontWeight: FontWeight.normal,
    ),
    // TEXTO - RÓTULOS ('EM ANDAMENTO'/'PREPARANDO')
    labelSmall: GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.normal,
    ),
  );

  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.tertiary, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.tertiary, width: 2.0), // Cor 1
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.error, width: 2.0),
    ),
    labelStyle: TextStyle(
      color: AppColors.tertiary, // Cor 4 para a label
    ),
    hintStyle: TextStyle(
      color: AppColors.text,
    ),
  );

  CardThemeData get cardTheme => CardThemeData(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: const Color.fromARGB(255, 190, 132, 98),
      ),
    ),
  );

  AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: colorScheme.tertiary,
    foregroundColor: AppColors.background,
    elevation: 0,
    scrolledUnderElevation: 0,
  );

  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      textStyle: textTheme.labelLarge,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  TextButtonThemeData get textButtonData => TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
  );

  FloatingActionButtonThemeData get floatingActionButtonThemeData => FloatingActionButtonThemeData(
    backgroundColor: colorScheme.tertiary,
    foregroundColor: Colors.white,
  );

  NavigationBarThemeData get navigationbarTheme => NavigationBarThemeData(
    backgroundColor: colorScheme.tertiary,
    indicatorColor: AppColors.title,
    labelTextStyle: WidgetStateProperty.all(
      TextStyle(color: colorScheme.secondary),
    ),
  );

  AlertDialog get dialog => AlertDialog(
    backgroundColor: colorScheme.onSecondary,
    titlePadding: const EdgeInsets.only(
      top: 20,
      left: 24,
      right: 24,
      bottom: 0,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    actionsPadding: const EdgeInsets.all(20),
  );
}
