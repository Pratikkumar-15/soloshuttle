import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0B1220);
  static const surface = Color(0xFF1A2433);
  static const surfaceLight = Color(0xFF243042);
  static const navigationSurface = Color(0xFF111827);
  
  // Accents
  static const primaryGreen = Color(0xFF2ECC71);
  static const teal = Color(0xFF16A085);
  static const emerald = Color(0xFF00B894);
  static const electricGreen = Color(0xFF00FF87);
  
  // Secondary Highlights
  static const orange = Color(0xFFFF9F43);
  static const purple = Color(0xFF6C5CE7);
  static const cyan = Color(0xFF00CEC9);
  static const red = Color(0xFFFF5252);
  
  // Text Colors
  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;
  static const textMuted = Colors.white54;
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primaryGreen, teal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const voiceCoachGradient = LinearGradient(
    colors: [purple, Color(0xFFa29bfe)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const reactionGradient = LinearGradient(
    colors: [orange, Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const cardGradient = LinearGradient(
    colors: [surface, surfaceLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
