import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/scaling.dart';

class UIHelpers {
  double width;
  double height;

  double blockSizeHorizontal;
  double blockSizeVertical;

  ScalingHelper scalingHelper;

  TextStyle headline;
  TextStyle title;
  TextStyle body;
  TextStyle buttonStyle;

  SizedBox verticalSpaceLow;
  SizedBox verticalSpaceMedium;
  SizedBox verticalSpaceHigh;

  SizedBox horizontalSpaceLow;
  SizedBox horizontalSpaceMedium;
  SizedBox horizontalSpaceHigh;

  UIHelpers.fromContext(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

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
        fontFamily: SystemProperties.fontName);

    title = TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: textPrimaryColor,
        decoration: TextDecoration.none,
        fontFamily: SystemProperties.fontName);
    buttonStyle = TextStyle(
        fontFamily: SystemProperties.fontName,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        fontSize: 14);

    body = TextStyle(
        color: textSecondaryColor,
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
