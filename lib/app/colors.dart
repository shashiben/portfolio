import 'package:flutter/material.dart';

//** Theme Colors
const primaryColor = Color(0xFF2D4CC8);
const backgroundColor = Color(0xFFe6e7ee);
const surfaceColor = Color(0xFFe5e6ed);

//** Text Colors
const Color textPrimaryColor = Color(0xFF31344b);
const Color textSecondaryColor = Color(0xFF53577b);

const Color dividerColor = Colors.black54;

const Color successColor = Colors.green;
const Color failureColor = Colors.red;

mixin lightColor {
  //** Theme Colors
  static Color primaryColor = Color(0xFF2D4CC8);
  static Color backgroundColor = Color(0xFFD7E5F0);
  static Color surfaceColor = Color(0xFFD7E5F0);

//** Text Colors
  static Color textPrimaryColor = Color(0xFF324B72);
  static Color textSecondaryColor = Color(0xFFD7E3F1);

  static Color dividerColor = Colors.black54;
}
mixin darkColor {
  //** Theme Colors
  static Color primaryColor = Color(0xFF2D4CC8);
  static Color backgroundColor = Colors.black;
  static Color surfaceColor = Colors.black;

//** Text Colors
  static Color textPrimaryColor = Colors.white;
  static Color textSecondaryColor = Colors.white54;

  static Color dividerColor = Colors.white54;
}
