import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color darkBlue = Color(0xFF1E40AF);
  static const Color lightBlue = Color(0xFFE8F1FF);
  static const Color accentBlue = Color(0xFF60A5FA);

  // Neutral Colors
  static const Color black = Color(0xFF1A1A1A);
  static const Color darkGray = Color(0xFF4B5563);
  static const Color mediumGray = Color(0xFF9CA3AF);
  static const Color lightGray = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color borderGray = Color(0xFFE5E7EB);

  // Background Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFE8F1FF), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get lightShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}