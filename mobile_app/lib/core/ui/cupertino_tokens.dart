import 'package:flutter/cupertino.dart';

/// Cupertino design tokens and constants for light mode only.
/// Centralizes Apple HIG-aligned colors, spacing, and radii.
class CupertinoTokens {
  // Colors (Mobbin Apple colors)
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemYellow = Color(0xFFFFCC00);

  static const Color background = Color(0xFFFFFFFF);
  static const Color secondaryBackground = Color(0xFFF2F2F7);
  static const Color separator = Color.fromRGBO(60, 60, 67, 0.29);

  // Spacing scale (in logical pixels)
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;

  // Corner radii
  static const double radiusButton = 10.0; // 8–12 typical
  static const double radiusCard = 12.0;

  // CupertinoThemeData for the app (light only)
  static const CupertinoThemeData theme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: systemBlue,
    scaffoldBackgroundColor: background,
    barBackgroundColor: background,
  );
}


