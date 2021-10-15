import 'package:flutter/material.dart';

// //** Theme Colors
// const primaryColor = Color(0xFF2D4CC8);
// const backgroundColor = Color(0xFFe6e7ee);
// const surfaceColor = Color(0xFFe5e6ed);

// //** Text Colors
// const Color textPrimaryColor = Color(0xFF31344b);
// const Color textSecondaryColor = Color(0xFF53577b);

// const Color dividerColor = Colors.black54;

// const Color successColor = Colors.green;
// const Color failureColor = Colors.red;

mixin lightColor {
  //** Theme Colors
  static Color primaryColor = const Color(0xFF31344B);
  static Color backgroundColor = const Color(0xFFe6e7ee);
  static Color surfaceColor = const Color(0xFFe6e7ee);

//** Text Colors
  static Color textPrimaryColor = const Color(0xFF31344B);
  static Color textSecondaryColor = const Color(0xFF44476A);

  static Color? dividerColor = Colors.grey[300];
}
mixin darkColor {
  //** Theme Colors
  static const primaryColor = Color(0xFFff9950);
  static const backgroundColor = Color(0xFF050028);
  static const surfaceColor = Color(0xFF1a163c);

  //**Text Colors
  static const Color textPrimaryColor = Color(0xFFCCD6F6);
  static const Color textSecondaryColor = Colors.white30;

  static const Color dividerColor = Colors.white60;
}
