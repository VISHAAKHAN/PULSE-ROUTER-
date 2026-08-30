import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepNavy,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.emergencyRed,
        secondary: AppColors.activeGreen,
        surface: AppColors.cardNavy,
        error: AppColors.emergencyRed,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).apply(
        bodyColor: AppColors.textWhite,
        displayColor: AppColors.textWhite,
      ),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    );
  }

  static TextStyle monoStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textWhite,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle plusJakartaStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.bold,
    Color color = AppColors.textWhite,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
