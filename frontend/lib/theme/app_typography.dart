import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Montserrat — headings, CTAs, card titles
  static TextStyle montserrat({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.black,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Nexa-like (Nunito) — body text, supporting copy
  static TextStyle body({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.darkGrey,
    double? height,
  }) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height ?? 1.5,
    );
  }

  // Caveat — handwritten accent
  static TextStyle caveat({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.blue,
  }) {
    return GoogleFonts.caveat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Preset styles
  static TextStyle get displayLarge => montserrat(
    fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.blue,
  );

  static TextStyle get headingLarge => montserrat(
    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.blue,
  );

  static TextStyle get headingMedium => montserrat(
    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.blue,
  );

  static TextStyle get headingSmall => montserrat(
    fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.blue,
  );

  static TextStyle get labelLarge => montserrat(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.blue,
  );

  static TextStyle get labelMedium => montserrat(
    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkGrey,
  );

  static TextStyle get bodyLarge => body(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get bodyMedium => body(fontSize: 14);

  static TextStyle get bodySmall => body(fontSize: 12, color: AppColors.darkGrey);

  static TextStyle get ctaStyle => montserrat(
    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white,
    letterSpacing: 0.3,
  );
}
