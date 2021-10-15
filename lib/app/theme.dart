import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/colors.dart';

final neumorphicLightTheme = NeumorphicThemeData(
    shadowLightColorEmboss: lightColor.backgroundColor,
    intensity: 0.4,
    baseColor: lightColor.surfaceColor,
    depth: 8,
    lightSource: LightSource.topLeft,
    iconTheme: IconThemeData(color: lightColor.primaryColor));
final neumorphicDarkTheme = NeumorphicThemeData(
    intensity: 0.3,
    shadowDarkColor: darkColor.backgroundColor,
    baseColor: darkColor.backgroundColor,
    iconTheme: IconThemeData(color: darkColor.primaryColor));
