import 'package:flutter/material.dart';

ThemeData criarTema() {
  const corPrincipal = Color(0xFFFA2408);

  return ThemeData(
    fontFamily: 'UberMove',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: corPrincipal,
      primary: corPrincipal,
      onPrimary: Colors.black,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: corPrincipal,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(
          fontFamily: 'UberMove',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

