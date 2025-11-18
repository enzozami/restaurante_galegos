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
    'principal': Color(0xFFE2943b), //Cor 1
    'secundaria': Color(0xFFe8bb87), // Cor 2
    'contraste': Color(0xFF734511), // Cor 3
    'neutro_escuro': Color(0xFF847c84), // Cor 4
    'neutro_claro': Color(0xFFbcb4bc), // Cor 5
    'texto_principal': Color(0xFF000000), // Cor 6
    'fundo_branco': Color(0xFFFFFAF5), // Cor 7
  };

  static final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    // Cores principais
    primary: colors['principal'] ?? Colors.black,
    secondary: colors['secundaria'] ?? Colors.black,
    tertiary: colors['contraste'] ?? Colors.black,
    // Cores de contraste
    onPrimary: colors['texto_principal'] ?? Colors.black,
    onSecondary: colors['contraste'] ?? Colors.black,
    onTertiary: colors['fundo_branco'] ?? Colors.black,
    // Cores erro
    error: const Color.fromRGBO(177, 0, 0, 1),
    onError: Colors.white,
    // Cores de fundo
    surface: colors['fundo_branco'] ?? Colors.black,
    onSurface: colors['texto_principal'] ?? Colors.black,
  );

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    // Cores de base e Fundo
    primaryColor: colors['principal'],
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors['neutro_claro'],

    // Exibição
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    // Textos
    textTheme: TextTheme(
      // Títulos Grandes (Ex: Cabeçalhos de Páginas)
      titleLarge: TextStyle(
        color: colors['texto_principal'], // Preto para alto contraste
        fontSize: 30, // Um pouco maior
        fontWeight: FontWeight.bold,
      ),
      // Títulos Médios (Ex: Nome do Prato)
      titleMedium: TextStyle(
        color: colors['texto_principal'],
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      // Texto de Descrição/Corpo (bodyLarge) - usa a cor de contraste
      bodyLarge: TextStyle(
        color: colors['contraste'], // Cor 3: Mais amigável que preto puro
        fontSize: 16,
      ),
      // Texto Secundário/Pequeno (bodySmall) - usa o neutro
      bodySmall: TextStyle(
        color: colors['neutro_escuro'], // Cor 4: Mais suave
        fontSize: 14,
      ),
    ),

    // --- Adição Importante: Campos de Formulário ---
    inputDecorationTheme: InputDecorationTheme(
      // Estilo padrão: Borda discreta com Cor 4
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors['neutro_escuro']!, width: 1.0),
      ),
      // Estilo de foco: Borda com a Cor Primária
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0), // Cor 1
      ),
      // Estilo de erro:
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      // Estilo para o texto (Label, Hint)
      labelStyle: TextStyle(
        color: colors['neutro_escuro'], // Cor 4 para a label
      ),
      hintStyle: TextStyle(
        color: colors['neutro_escuro']!.withValues(alpha: 0.6),
      ),
      // Preenchimento do campo (opcional, mas comum)
      filled: true,
      fillColor: Colors.white,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: colors['contraste'],
      foregroundColor: colors['fundo_branco'],
      // backgroundColor: colorScheme.secondary,
      // foregroundColor: colors['contraste'],
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    // Botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        // iconColor: Color(0xffE2933C),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Botões de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.tertiary,
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.tertiary,
      foregroundColor: Colors.white,
    ),

    // NavigationBar
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colorScheme.secondary,
      backgroundColor: colorScheme.tertiary,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(
          color: colorScheme.secondary,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colorScheme.tertiary);
        }
        return IconThemeData(color: colorScheme.primary);
      }),
    ),
  );
}

/*
GERADO PELO GEMINI


import 'package:flutter/material.dart';

class GalegosUiDefaut {
  GalegosUiDefaut._();

  /*
  .color1 { #e2943b }; (Principal/Ação)
  .color2 { #e8bb87 }; (Secundária Suave)
  .color3 { #734511 }; (Contraste/Destaque Escuro)
  .color4 { #847c84 }; (Neutro Escuro/Ícones Inativos)
  .color5 { #bcb4bc }; (Neutro Claro/Fundo Secundário)
  */

  static final Map<String, Color> colors = <String, Color>{
    'principal': const Color(0xFFE2943B), // Cor 1
    'secundaria': const Color(0xFFE8BB87), // Cor 2 (Corrigido o acento)
    'contraste': const Color(0xFF734511), // Cor 3
    'neutro_escuro': const Color(0xFF847C84), // Cor 4
    'neutro_claro': const Color(0xFFBCB4BC), // Cor 5
    'texto_principal': const Color(0xFF000000), // Cor 6
    'fundo_branco': Colors.white, // Usando o const Colors.white nativo
  };

  static final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    // Cores principais
    primary: colors['principal']!, 
    secondary: colors['secundaria']!, // Chave corrigida
    tertiary: colors['contraste']!,
    // Cores de contraste
    onPrimary: colors['texto_principal']!, // Preto sobre o Laranja/Ouro
    onSecondary: colors['contraste']!,
    onTertiary: colors['fundo_branco']!, // Branco sobre o Contraste (Cor 3)
    // Cores erro
    error: const Color(0xFFB10000), 
    onError: Colors.white,
    // Cores de fundo
    surface: colors['fundo_branco']!, // Para Cards
    onSurface: colors['texto_principal']!,
    background: colors['fundo_branco']!, // Fundo para a maioria dos widgets
    onBackground: colors['texto_principal']!,
  );

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    // Cores de base e Fundo
    colorScheme: colorScheme,
    primaryColor: colors['principal'],
    scaffoldBackgroundColor: colors['neutro_claro'], // Cor 5 para fundo do Scaffold

    // Exibição
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    // Textos (Ajustado para clareza e hierarquia)
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: colors['texto_principal'],
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: colors['texto_principal'],
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: colors['contraste'], // Cor 3 para texto de corpo (personalidade)
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        color: colors['neutro_escuro'], // Cor 4 para textos secundários
        fontSize: 14,
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: colors['neutro_claro'],
      foregroundColor: colors['contraste'],
      elevation: 0,
      scrolledUnderElevation: 0,
    ),

    // Botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary, // Cor 1
        foregroundColor: colorScheme.onPrimary, // Preto
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Botões de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.tertiary, // Cor 3 para links
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.tertiary, // Cor 3
      foregroundColor: Colors.white,
    ),

    // NavigationBar
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colors['principal'],
      backgroundColor: colorScheme.tertiary, // Cor 3
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Colors.white,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colors['principal']);
        }
        return IconThemeData(color: colors['secundaria']); // Cor 2 para inativo
      }),
    ),
    
    // --- NOVO: Campos de Formulário ---
    inputDecorationTheme: InputDecorationTheme(
      // Estilo padrão
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors['neutro_escuro']!, width: 1.0),
      ),
      // Estilo focado (Usa a cor principal)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      // Estilo de erro
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      // Cor de texto e dica
      labelStyle: TextStyle(
        color: colors['neutro_escuro'],
      ),
      hintStyle: TextStyle(
        color: colors['neutro_escuro']!.withOpacity(0.6),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}

*/
