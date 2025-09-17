import 'package:flutter/material.dart';

class AppTheme {
  // Apple HIG inspired Light palette
  // Foundation (iOS system)
  static const Color white = Color(0xFFFFFFFF);            // systemBackground
  static const Color softGrey = Color(0xFFF2F2F7);         // secondarySystemBackground

  // System colors
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemYellow = Color(0xFFFFCC00);
  static const Color systemIndigo = Color(0xFF5856D6);

  // Backward-compat for code already using these names
  static const Color deepTeal = white;                      // now light background
  static const Color emeraldGreen = systemGreen;
  static const Color brightGold = systemYellow;             // CTA color
  static const Color black = Color(0xFF000000);             // label
  static const Color gray  = Color(0xFF8E8E93);             // secondary label

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: white,
      colorScheme: const ColorScheme.light(
        primary: systemBlue,
        secondary: systemGreen,
        surface: softGrey,
        background: white,
        onPrimary: white,
        onSecondary: white,
        onSurface: black,
        onBackground: black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: systemYellow,
          foregroundColor: black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: black,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: black,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: black,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: gray,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    // Removed: we no longer support dark mode.
    return lightTheme;
  }
}
