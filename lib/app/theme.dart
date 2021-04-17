import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/colors.dart';

final neumorphicLightTheme = NeumorphicThemeData(
    baseColor: surfaceColor,
    depth: 10,
    lightSource: LightSource.topLeft,
    iconTheme: IconThemeData(color: primaryColor));
final neumorphicDarkTheme = NeumorphicThemeData(
    shadowDarkColor: darkColor.backgroundColor,
    baseColor: Colors.black,
    iconTheme: IconThemeData(color: primaryColor));
