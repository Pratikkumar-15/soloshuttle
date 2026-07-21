import 'package:flutter/material.dart';

abstract final class AppColors {
  // Court Form Theme Colors
  static const courtBackground = Color(0xFF081C16);
  static const courtSurface = Color(0xFF0E2A21);
  static const chalkWhite = Color(0xFFEEE9DC);
  static const sageGray = Color(0xFF9CB3A7);
  static const corkGold = Color(0xFFF0B429);
  static const limeGreen = Color(0xFFC4E93D);

  // Category Accents
  static const skyBlue = Color(0xFF4FB6E8);
  static const softViolet = Color(0xFF9E8CF2);
  static const coral = Color(0xFFFF6B4A);
  static const tealSage = Color(0xFF2ECC71);

  // Base colors
  static const background = Color(0xFF081C16);
  static const surface = Color(0xFF0E2A21);
  static const surfaceLight = Color(0xFF143B2E);
  static const navigationSurface = Color(0xFF081C16);

  // Accents
  static const primaryGreen = Color(0xFFC4E93D);
  static const teal = Color(0xFF4FB6E8);
  static const emerald = Color(0xFF2ECC71);
  static const electricGreen = Color(0xFFC4E93D);

  // Secondary Highlights
  static const orange = Color(0xFFFF6B4A);
  static const purple = Color(0xFF9E8CF2);
  static const cyan = Color(0xFF4FB6E8);
  static const red = Color(0xFFFF6B4A);

  // Text Colors
  static const textPrimary = Color(0xFFEEE9DC);
  static const textSecondary = Color(0xFF9CB3A7);
  static const textMuted = Color(0xFF6E857A);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF2ECC71), Color(0xFFC4E93D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const xpGradient = LinearGradient(
    colors: [Color(0xFF2ECC71), Color(0xFFC4E93D)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const voiceCoachGradient = LinearGradient(
    colors: [softViolet, Color(0xFFA29BFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const reactionGradient = LinearGradient(
    colors: [coral, Color(0xFFFF9F43)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGradient = LinearGradient(
    colors: [surface, surfaceLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
