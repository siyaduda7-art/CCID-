import 'package:flutter/material.dart';

class CcidColors {
  static const Color lime = Color(0xFFA3D900);
  static const Color darkGreen = Color(0xFF005A2B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF1A1A1A);
  static const Color lightBackground = Color(0xFFF4F8F4);

  static const Color emergencyRed = Color(0xFFD32F2F);
  static const Color safetyGreen = Color(0xFF16A34A);
  static const Color warningAmber = Color(0xFFF59E0B);
}

class CcidTheme {
  static ThemeData theme() {
    final base = ThemeData(useMaterial3: true);

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: CcidColors.darkGreen,
        primary: CcidColors.darkGreen,
        secondary: CcidColors.lime,
        surface: CcidColors.white,
      ),
      scaffoldBackgroundColor: CcidColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: CcidColors.darkGreen,
        foregroundColor: CcidColors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CcidColors.darkGreen,
          foregroundColor: CcidColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CcidColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}