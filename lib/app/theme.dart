import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/strings.dart';

final lightTheme = (BuildContext context) => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: fontName,
    textTheme: Theme.of(context)
        .textTheme
        .apply(bodyColor: textPrimaryColor, fontFamily: fontName),
    iconTheme: IconThemeData(color: primaryColor));
