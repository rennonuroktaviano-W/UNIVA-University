import 'package:flutter/material.dart';

class K {
  static const ink = Color(0xFF14111F);
  static const plum = Color(0xFF1F1B2E);
  static const coral = Color(0xFFFF6B57);
  static const sun = Color(0xFFFFC857);
  static const mint = Color(0xFF5EEAD4);
  static const lilac = Color(0xFFB8A4FF);
  static const text = Color(0xFFF5F1FF);
  static const muted = Color(0xFF9B94B5);
}

ThemeData univaTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: K.ink,
      colorScheme: const ColorScheme.dark(primary: K.coral, surface: K.plum),
    );
