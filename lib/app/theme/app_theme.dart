import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tokens/tokens.dart';
import 'app_theme_colors.dart';

abstract final class AppTheme {
  /// Dark-only app: [light] resolves to the same Omnitrix look as [dark].
  static ThemeData light() => _omni(AppThemeColors.light());

  static ThemeData dark() => _omni(AppThemeColors.dark());

  static const OutlinedBorder _hudShape = BeveledRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
  );

  static ThemeData _omni(AppThemeColors colors) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: ColorTokens.darkBg1,
        onSurface: ColorTokens.darkTextPrimary,
        primary: ColorTokens.darkAccent,
        onPrimary: ColorTokens.darkBg0,
        secondary: ColorTokens.darkAccentPurple,
        onSecondary: ColorTokens.darkTextPrimary,
        tertiary: ColorTokens.darkAccent,
        onTertiary: ColorTokens.darkBg0,
        error: ColorTokens.darkDanger,
        outline: ColorTokens.darkLine,
      ),
    );
    final textTheme = _buildTextTheme(base.textTheme)
        .apply(bodyColor: ColorTokens.darkTextPrimary, displayColor: ColorTokens.darkTextPrimary);
    return base.copyWith(
      scaffoldBackgroundColor: ColorTokens.darkBg0,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: ColorTokens.darkTextPrimary),
        iconTheme: const IconThemeData(color: ColorTokens.darkTextPrimary),
      ),
      dividerColor: ColorTokens.darkLine,
      cardColor: ColorTokens.darkBg1,
      splashFactory: InkSparkle.splashFactory,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorTokens.darkAccent,
        selectionColor: ColorTokens.darkAccent.withValues(alpha: 0.3),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ColorTokens.darkAccent,
          foregroundColor: ColorTokens.darkBg0,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: _hudShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorTokens.darkAccent,
          side: const BorderSide(color: ColorTokens.darkAccent),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: _hudShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorTokens.darkTextSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      extensions: [colors],
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    TextStyle display(
      TextStyle? style, {
      double? fontSize,
      double? height,
      FontWeight? fontWeight,
      double? letterSpacing,
    }) {
      return GoogleFonts.chakraPetch(
        textStyle: style,
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );
    }

    TextStyle body(TextStyle? style, {double? fontSize, double? height, FontWeight? fontWeight}) {
      return GoogleFonts.inter(textStyle: style, fontSize: fontSize, height: height, fontWeight: fontWeight);
    }

    TextStyle mono(TextStyle? style, {double? fontSize, FontWeight? fontWeight, double? letterSpacing}) {
      return GoogleFonts.jetBrainsMono(
        textStyle: style,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );
    }

    return base.copyWith(
      displayLarge: display(
        base.displayLarge,
        fontSize: 48,
        height: 1.05,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: display(
        base.displayMedium,
        fontSize: 32,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      displaySmall: display(base.displaySmall, fontWeight: FontWeight.w600),
      headlineLarge: display(base.headlineLarge, fontWeight: FontWeight.w600),
      headlineMedium: display(base.headlineMedium, fontWeight: FontWeight.w600),
      headlineSmall: display(base.headlineSmall, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 1.2),
      titleLarge: display(base.titleLarge, fontSize: 18, height: 1.2, fontWeight: FontWeight.w600),
      titleMedium: display(base.titleMedium, fontWeight: FontWeight.w600),
      titleSmall: display(base.titleSmall, fontWeight: FontWeight.w600),
      bodyLarge: body(base.bodyLarge, fontSize: 16, height: 1.5, fontWeight: FontWeight.w400),
      bodyMedium: body(base.bodyMedium, fontSize: 14, height: 1.5, fontWeight: FontWeight.w400),
      bodySmall: body(base.bodySmall),
      labelLarge: mono(base.labelLarge, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8),
      labelMedium: mono(base.labelMedium, letterSpacing: 1.0),
      labelSmall: mono(base.labelSmall, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1.6),
    );
  }
}
