import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tokens/tokens.dart';
import 'app_theme_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        surface: ColorTokens.lightBg1,
        onSurface: ColorTokens.lightTextPrimary,
        primary: ColorTokens.lightAccent,
        onPrimary: Colors.white,
        secondary: ColorTokens.lightAccentPurple,
        onSecondary: Colors.white,
        tertiary: ColorTokens.lightAccent,
        onTertiary: Colors.white,
        outline: ColorTokens.lightLine,
      ),
    );
    final textTheme = _buildTextTheme(base.textTheme);
    return base.copyWith(
      scaffoldBackgroundColor: ColorTokens.lightBg0,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: ColorTokens.lightTextPrimary,
        ),
        iconTheme: const IconThemeData(color: ColorTokens.lightTextPrimary),
      ),
      dividerColor: ColorTokens.lightLine,
      cardColor: ColorTokens.lightBg1,
      splashFactory: InkSparkle.splashFactory,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ColorTokens.lightAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorTokens.lightTextPrimary,
          side: const BorderSide(color: ColorTokens.lightLine),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorTokens.lightTextSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      extensions: [AppThemeColors.light()],
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: ColorTokens.darkBg1,
        onSurface: ColorTokens.darkTextPrimary,
        primary: ColorTokens.darkAccent,
        onPrimary: ColorTokens.darkBg0,
        outline: ColorTokens.darkLine,
      ),
    );
    final textTheme = _buildTextTheme(base.textTheme);
    return base.copyWith(
      scaffoldBackgroundColor: ColorTokens.darkBg0,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: ColorTokens.darkTextPrimary,
        ),
        iconTheme: const IconThemeData(color: ColorTokens.darkTextPrimary),
      ),
      dividerColor: ColorTokens.darkLine,
      cardColor: ColorTokens.darkBg1,
      splashFactory: InkSparkle.splashFactory,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ColorTokens.darkAccent,
          foregroundColor: ColorTokens.darkBg0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorTokens.darkTextPrimary,
          side: const BorderSide(color: ColorTokens.darkLine),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorTokens.darkTextSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      extensions: [AppThemeColors.dark()],
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.spaceGroteskTextTheme(base).copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 48,
        height: 1.05,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        height: 1.12,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        height: 1.2,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.spaceGrotesk(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: GoogleFonts.spaceGrotesk(
        fontSize: 13,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      headlineSmall: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}
