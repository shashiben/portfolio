import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/scaling.dart';

class ScreenUiHelper {
  double width;
  double height;

  double blockSizeHorizontal;
  double blockSizeVertical;

  ScalingHelper scalingHelper;

  TextStyle headline;
  TextStyle title;
  TextStyle body;
  TextStyle buttonStyle;

  Color surfaceColor;
  Color backgroundColor;
  Color primaryColor;
  Color textPrimaryColor;
  Color textSecondaryColor;
  Color dividerColor;

  NeumorphicTextStyle headlineTextStyle;
  NeumorphicTextStyle titleTextStyle;
  NeumorphicTextStyle bodyTextStyle;
  NeumorphicTextStyle buttonTextStyle;

  SizedBox verticalSpaceLow;
  SizedBox verticalSpaceMedium;
  SizedBox verticalSpaceHigh;

  SizedBox horizontalSpaceLow;
  SizedBox horizontalSpaceMedium;
  SizedBox horizontalSpaceHigh;

  ScreenUiHelper.fromContext(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    surfaceColor = NeumorphicTheme.of(context).isUsingDark
        ? darkColor.surfaceColor
        : lightColor.surfaceColor;
    backgroundColor = NeumorphicTheme.of(context).isUsingDark
        ? darkColor.backgroundColor
        : lightColor.backgroundColor;
    primaryColor = NeumorphicTheme.of(context).isUsingDark
        ? darkColor.primaryColor
        : lightColor.primaryColor;
    textPrimaryColor = NeumorphicTheme.of(context).isUsingDark
        ? darkColor.textPrimaryColor
        : lightColor.textPrimaryColor;
    textSecondaryColor = NeumorphicTheme.of(context).isUsingDark
        ? darkColor.textSecondaryColor
        : lightColor.textSecondaryColor;
    dividerColor = NeumorphicTheme.of(context).isUsingDark
        ? darkColor.dividerColor
        : lightColor.dividerColor;

    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    width = screenWidth;
    height = screenHeight;

    scalingHelper = ScalingHelper(width: screenWidth);

    headline = TextStyle(
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
        fontSize: 24,
        decoration: TextDecoration.none,
        fontFamily: SystemProperties.titleFont);

    title = TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: textPrimaryColor,
        decoration: TextDecoration.none,
        fontFamily: SystemProperties.titleFont);
    buttonStyle = TextStyle(
        fontFamily: SystemProperties.titleFont,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
        fontSize: 14);

    body = TextStyle(
        color: textSecondaryColor,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        decoration: TextDecoration.none,
        fontFamily: SystemProperties.fontName);

    headlineTextStyle = NeumorphicTextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        decoration: TextDecoration.none,
        fontFamily: SystemProperties.titleFont);

    titleTextStyle = NeumorphicTextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        decoration: TextDecoration.none,
        fontFamily: SystemProperties.titleFont);
    buttonTextStyle = NeumorphicTextStyle(
        fontFamily: SystemProperties.titleFont,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        fontSize: 14);

    bodyTextStyle = NeumorphicTextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        decoration: TextDecoration.none,
        fontFamily: SystemProperties.fontName);

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    verticalSpaceLow = SizedBox(
      height: blockSizeVertical * 1.5,
    );
    verticalSpaceMedium = SizedBox(
      height: blockSizeVertical * 4,
    );
    verticalSpaceHigh = SizedBox(
      height: blockSizeVertical * 6,
    );

    horizontalSpaceLow = SizedBox(
      width: blockSizeHorizontal * 1.5,
    );
    horizontalSpaceMedium = SizedBox(
      width: blockSizeHorizontal * 7,
    );
    horizontalSpaceHigh = SizedBox(
      width: blockSizeHorizontal * 11,
    );
  }
}
