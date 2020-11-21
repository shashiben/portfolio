import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/strings.dart';
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
        color: textPrimary,
        fontSize: scalingHelper.size(24),
        decoration: TextDecoration.none,
        fontFamily: fontName);

    title = TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: scalingHelper.size(18),
        color: textPrimary,
        decoration: TextDecoration.none,
        fontFamily: fontName);
    buttonStyle = TextStyle(
        fontFamily: fontName,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        fontSize: scalingHelper.size(14));

    body = TextStyle(
        color: textSecondary,
        fontWeight: FontWeight.w400,
        fontSize: scalingHelper.size(14),
        decoration: TextDecoration.none,
        fontFamily: fontName);

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
      width: blockSizeHorizontal * 3,
    );
    horizontalSpaceMedium = SizedBox(
      width: blockSizeHorizontal * 7,
    );
    horizontalSpaceHigh = SizedBox(
      width: blockSizeHorizontal * 11,
    );
  }
}
