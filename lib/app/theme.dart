import 'package:flutter/material.dart';

/// Tema do app, centralizado para as telas nao definirem cor na mao.
class AppTheme {
  const AppTheme._();

  static const Color _primary = Color(0xFF1E88E5);
  static const Color _tertiary = Color(0xFFFF7043);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primary,
          primary: _primary,
          onPrimary: Colors.white,
          tertiary: _tertiary,
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
        ),
      );
}
