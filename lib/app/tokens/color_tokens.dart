import 'package:flutter/material.dart';

abstract final class ColorTokens {
  static const Color omniVoid = Color(0xFF050806);
  static const Color omniPanel = Color(0xFF0B120D);
  static const Color omniPanelLifted = Color(0xFF101A13);
  static const Color omniLine = Color(0xFF1C2B1F);
  static const Color omniGreen = Color(0xFF39FF14);
  static const Color omniDeepGreen = Color(0xFF0F7A2A);
  static const Color omniTextPrimary = Color(0xFFEAFBEA);
  static const Color omniTextSecondary = Color(0xFF8FA893);
  static const Color omniTextTertiary = Color(0xFF55695A);
  static const Color omniAmber = Color(0xFFFFB020);
  static const Color omniRed = Color(0xFFFF2E3A);

  // Light tokens intentionally mirror dark: the app is dark-only.
  static const Color lightBg0 = omniVoid;
  static const Color lightBg1 = omniPanel;
  static const Color lightBg2 = omniPanelLifted;
  static const Color lightLine = omniLine;
  static const Color lightTextPrimary = omniTextPrimary;
  static const Color lightTextSecondary = omniTextSecondary;
  static const Color lightTextTertiary = omniTextTertiary;
  static const Color lightAccent = omniGreen;
  static const Color lightAccentPurple = omniDeepGreen;
  static const Color lightSuccess = omniGreen;
  static const Color lightWarning = omniAmber;
  static const Color lightDanger = omniRed;

  static const Color darkBg0 = omniVoid;
  static const Color darkBg1 = omniPanel;
  static const Color darkBg2 = omniPanelLifted;
  static const Color darkLine = omniLine;
  static const Color darkTextPrimary = omniTextPrimary;
  static const Color darkTextSecondary = omniTextSecondary;
  static const Color darkTextTertiary = omniTextTertiary;
  static const Color darkAccent = omniGreen;
  static const Color darkAccentPurple = omniDeepGreen;
  static const Color darkSuccess = omniGreen;
  static const Color darkWarning = omniAmber;
  static const Color darkDanger = omniRed;
}
