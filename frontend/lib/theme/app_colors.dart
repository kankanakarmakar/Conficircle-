import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color blue = Color(0xFF173883);
  static const Color coral = Color(0xFFF2432C);
  static const Color lightBlue = Color(0xFF4475D7);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFE4E4E4);
  static const Color softGrey = Color(0xFFF9F9F9);
  static const Color darkGrey = Color(0xFF555555);
  static const Color black = Color(0xFF1A1A2E);

  // Semantic
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF2980B9);

  // Card backgrounds
  static const Color cardBg1 = Color(0xFF1A2F6B);   // dark blue card
  static const Color cardBg2 = Color(0xFFE8F0FE);   // light blue card
  static const Color cardBg3 = Color(0xFFFEECEA);   // light coral card

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF173883), Color(0xFF4475D7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coralGradient = LinearGradient(
    colors: [Color(0xFFF2432C), Color(0xFFFF6B4A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softBlueGradient = LinearGradient(
    colors: [Color(0xFFE8F0FE), Color(0xFFD0E2FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
