import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'colors.dart';

final neumorphicLightTheme = NeumorphicThemeData(
    shadowLightColorEmboss: lightColor.backgroundColor,
    intensity: 0.4,
    baseColor: lightColor.surfaceColor,
    depth: 8,
    iconTheme: IconThemeData(color: lightColor.primaryColor));
const neumorphicDarkTheme = NeumorphicThemeData(
    intensity: 0.3,
    shadowDarkColor: darkColor.backgroundColor,
    baseColor: darkColor.backgroundColor,
    iconTheme: IconThemeData(color: darkColor.primaryColor));
