import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static const background = Color(0xFF0B1220);
  static const surface = Color(0xFF1A2433);
  static const navigationSurface = Color(0xFF111827);
  static const green = Color(0xFF2ECC71);
  static const teal = Color(0xFF16A085);
  static const mutedText = Colors.white60;

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: green,
        surface: surface,
      ),
    );
  }
}
