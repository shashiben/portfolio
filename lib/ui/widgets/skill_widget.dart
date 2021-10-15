import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SkillWidget extends StatelessWidget {
  final TextStyle? textStyle;

  const SkillWidget({Key? key, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    return ScreenTypeLayout(
      mobile: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: PersonalDetails.skillsList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FlutterIcons.play_mco,
                color: uiHelper.primaryColor,
                size: 20,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                PersonalDetails.skillsList[index],
                style: textStyle ??
                    TextStyle(
                      color: uiHelper.textPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              )
            ],
          ),
        ),
      ),
      tablet: GridView.builder(
        itemCount: PersonalDetails.skillsList.length,
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 6, crossAxisCount: 2),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FlutterIcons.play_mco,
                color: uiHelper.primaryColor,
                size: 20,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                PersonalDetails.skillsList[index],
                style: textStyle ??
                    TextStyle(
                      fontSize: 16,
                      color: uiHelper.textPrimaryColor,
                      fontWeight: FontWeight.w400,
                    ),
              )
            ],
          ),
        ),
      ),
      desktop: GridView.builder(
        itemCount: PersonalDetails.skillsList.length,
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8, crossAxisCount: 2),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FlutterIcons.play_mco,
                color: uiHelper.primaryColor,
                size: 20,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                PersonalDetails.skillsList[index],
                style: textStyle ??
                    TextStyle(
                      color: uiHelper.textPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
