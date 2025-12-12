import 'package:flutter/material.dart';

class GalegosUiDefaut {
  GalegosUiDefaut._();

  /*
  .color1 { #e2943b };
  .color2 { #e8bb87 };
  .color3 { #734511 };
  .color4 { #847c84 };
  .color5 { #bcb4bc };
  */

  static final Map<String, Color> colors = <String, Color>{
    'primary': Color(0xFFE2943b), // botoes e textos especiais
    'secondary': Color(0xFFe8bb87), // ainda nao sei....
    'tertiary': Color.fromARGB(255, 61, 39, 30), // texto principal - appBar - navigationBar
    'titulo': Color(0xFF734511), // texto principal - appBar - navigationBar
    'texto': Color(0xFFA25F13), // texto principal - appBar - navigationBar
    'fundo': Color(0xFFFFFAF5), // surface
  };

  static final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    // Principal (appBar, navBar)
    primary: colors['primary'] ?? Color(0xFFE2943b),
    onPrimary: Color(0xFF442400),
    // Secundária — tons próximos e suaves
    secondary: colors['secondary'] ?? Color(0xFFe8bb87),
    onSecondary: Color(0xFF000000),
    // Terceária — texto principal marrom/terra
    tertiary: colors['tertiary'] ?? Color(0xFF734511),
    onTertiary: Color(0xFFFFFFFF),
    // Erro padrão
    error: Colors.red.shade700,
    onError: Colors.white,
    // Superfícies
    surface: colors['fundo'] ?? Color(0xFFFFFAF5),
    onSurface: Color(0xFF3D3028),
  );

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    // Cores de base e Fundo
    //primaryColor: colors['principal'],
    colorScheme: colorScheme,
    //scaffoldBackgroundColor: colors['neutro_claro'],

    // Exibição
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    // Textos
    textTheme: TextTheme(
      // Títulos Grandes (Ex: Cabeçalhos de Páginas)
      titleLarge: TextStyle(color: colors['titulo'], fontSize: 30, fontWeight: FontWeight.bold),
      // Títulos Médios (Ex: Nome do Prato)
      titleMedium: TextStyle(color: colors['titulo'], fontSize: 22, fontWeight: FontWeight.bold),
      // Titulo Pequeno (Ex: Nome da Marmita)
      titleSmall: TextStyle(color: colors['titulo'], fontSize: 18, fontWeight: FontWeight.bold),
      // Texto de Descrição/Corpo (bodyLarge) - usa a cor de contraste
      bodyLarge: TextStyle(color: colors['texto'], fontSize: 16),

      bodyMedium: TextStyle(color: colors['titulo'], fontSize: 14),
      // Texto Secundário/Pequeno (bodySmall) - usa o neutro
      bodySmall: TextStyle(color: colors['texto'], fontSize: 12),
    ),

    // --- Adição Importante: Campos de Formulário ---
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.tertiary, width: 1.0),
      ),
      // Estilo de foco: Borda com a Cor Primária
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.tertiary, width: 2.0), // Cor 1
      ),
      // Estilo de erro:
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      // Estilo para o texto (Label, Hint)
      labelStyle: TextStyle(
        color: colors['tertiary'], // Cor 4 para a label
      ),
      hintStyle: TextStyle(color: colors['texto'] ?? Colors.black.withValues(alpha: 0.6)),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.tertiary,
      foregroundColor: colors['fundo'],
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    // Botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Botões de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.tertiary,
      foregroundColor: Colors.white,
    ),

    // NavigationBar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.tertiary,

      indicatorColor: colors['texto'],
      labelTextStyle: WidgetStateProperty.all(TextStyle(color: colorScheme.secondary)),
    ),

    // SplashColor
    splashColor: colorScheme.tertiary,
  );

  static final TextTheme textProduct = TextTheme(
    titleMedium: TextStyle(color: colors['primary'], fontSize: 20, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: colors['titulo'], fontSize: 18),
    titleSmall: TextStyle(color: colors['primary'], fontSize: 16, fontWeight: FontWeight.bold),
  );

  static final TextTheme textLunchboxes = TextTheme(
    titleLarge: TextStyle(color: colors['titulo'], fontSize: 20, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: colors['fundo'], fontSize: 20, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(color: colors['fundo'], fontSize: 16, fontWeight: FontWeight.bold),
  );
}
