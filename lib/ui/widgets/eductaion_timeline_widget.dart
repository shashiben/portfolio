import 'package:flutter/material.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';

class EducationDetailsTimelineWidget extends StatelessWidget {
  final String year;
  final String name;
  final String stream;
  final double percentage;

  const EducationDetailsTimelineWidget(
      {Key key,
      @required this.year,
      @required this.name,
      @required this.stream,
      @required this.percentage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: uiHelper.body
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w200),
            ),
            Text(
              stream,
              style: uiHelper.title.copyWith(
                  fontSize: 20,
                  fontFamily: SystemProperties.fontName,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: uiHelper.title.copyWith(fontSize: 16),
            ),
            SizedBox(height: 4),
            RichText(
              text: TextSpan(
                  text: "Percentage: ",
                  style: uiHelper.title
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w300),
                  children: [
                    TextSpan(
                        text: "$percentage",
                        style: uiHelper.title.copyWith(
                            fontSize: 14,
                            color: uiHelper.primaryColor,
                            fontWeight: FontWeight.bold))
                  ]),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
