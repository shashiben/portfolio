import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors._({
    required this.bg0,
    required this.bg1,
    required this.bg2,
    required this.line,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentPurple,
    required this.success,
    required this.warning,
    required this.danger,
  });

  factory AppThemeColors.light() => AppThemeColors._(
        bg0: ColorTokens.lightBg0,
        bg1: ColorTokens.lightBg1,
        bg2: ColorTokens.lightBg2,
        line: ColorTokens.lightLine,
        textPrimary: ColorTokens.lightTextPrimary,
        textSecondary: ColorTokens.lightTextSecondary,
        textTertiary: ColorTokens.lightTextTertiary,
        accent: ColorTokens.lightAccent,
        accentPurple: ColorTokens.lightAccentPurple,
        success: ColorTokens.lightSuccess,
        warning: ColorTokens.lightWarning,
        danger: ColorTokens.lightDanger,
      );

  factory AppThemeColors.dark() => AppThemeColors._(
        bg0: ColorTokens.darkBg0,
        bg1: ColorTokens.darkBg1,
        bg2: ColorTokens.darkBg2,
        line: ColorTokens.darkLine,
        textPrimary: ColorTokens.darkTextPrimary,
        textSecondary: ColorTokens.darkTextSecondary,
        textTertiary: ColorTokens.darkTextTertiary,
        accent: ColorTokens.darkAccent,
        accentPurple: ColorTokens.darkAccentPurple,
        success: ColorTokens.darkSuccess,
        warning: ColorTokens.darkWarning,
        danger: ColorTokens.darkDanger,
      );

  final Color bg0;
  final Color bg1;
  final Color bg2;
  final Color line;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentPurple;
  final Color success;
  final Color warning;
  final Color danger;

  @override
  AppThemeColors copyWith({
    Color? bg0,
    Color? bg1,
    Color? bg2,
    Color? line,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentPurple,
    Color? success,
    Color? warning,
    Color? danger,
  }) =>
      AppThemeColors._(
        bg0: bg0 ?? this.bg0,
        bg1: bg1 ?? this.bg1,
        bg2: bg2 ?? this.bg2,
        line: line ?? this.line,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textTertiary: textTertiary ?? this.textTertiary,
        accent: accent ?? this.accent,
        accentPurple: accentPurple ?? this.accentPurple,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        danger: danger ?? this.danger,
      );

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors._(
      bg0: Color.lerp(bg0, other.bg0, t)!,
      bg1: Color.lerp(bg1, other.bg1, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      line: Color.lerp(line, other.line, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appColors => Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light();
}
