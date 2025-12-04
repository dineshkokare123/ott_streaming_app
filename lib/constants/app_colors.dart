import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE50914); // Netflix Red
  static const Color primaryDark = Color(0xFFB20710);
  static const Color primaryLight = Color(0xFFFF4158);

  // Background Colors
  static const Color background = Color(0xFF141414);
  static const Color backgroundLight = Color(0xFF1F1F1F);
  static const Color backgroundDark = Color(0xFF000000);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF808080);

  // Accent Colors
  static const Color accent = Color(0xFF00D9FF);
  static const Color success = Color(0xFF46D369);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF3B30);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE50914), Color(0xFFFF4158)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF141414)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFF1F1F1F);
  static const Color shimmerHighlight = Color(0xFF2D2D2D);
}
