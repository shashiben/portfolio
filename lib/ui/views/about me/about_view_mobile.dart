import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';
import 'package:portfolio/ui/views/about%20me/about_view_model.dart';
import 'package:portfolio/ui/widgets/linear_percent_indicator.dart';
import 'package:portfolio/ui/widgets/timeline_widget.dart';

class AboutMobileView extends StatelessWidget {
  final UIHelpers uiHelpers;
  final AboutViewModel model;

  const AboutMobileView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wow, a whole page about my journey!",
                style: uiHelpers.headline.copyWith(fontSize: 26),
              ),
              uiHelpers.verticalSpaceHigh,
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Me,talking about myself",
                      style: uiHelpers.title.copyWith(fontSize: 20),
                    ),
                    Container(
                      width: uiHelpers.width * 0.45,
                      child: Divider(
                        color: Colors.white60,
                        thickness: 2.5,
                      ),
                    ),
                    uiHelpers.verticalSpaceLow,
                    Container(
                      child: Text(
                          'A Full stack developer from Andhra Pradesh,India. Intrested in building mobile applications and web applications with flutter . Recently started developing web apps with react. And had a little knowledge in Opencv.',
                          style: uiHelpers.body.copyWith(
                              color: textSecondaryColor.withOpacity(0.4))),
                    ),
                    uiHelpers.verticalSpaceMedium,
                    Text(
                      "Technical Skills",
                      style: uiHelpers.title.copyWith(fontSize: 24),
                    ),
                    Container(
                      width: uiHelpers.width * 0.4,
                      child: Divider(
                        color: Colors.white60,
                        thickness: 2.5,
                      ),
                    ),
                    uiHelpers.verticalSpaceLow,
                    Container(
                      width: uiHelpers.width * 0.8,
                      child: LinearPercentIndicator(
                        progressColor: primaryColor,
                        title: "Flutter",
                        percent: 0.96,
                      ),
                    ),
                    Container(
                      width: uiHelpers.width * 0.8,
                      child: LinearPercentIndicator(
                        progressColor: primaryColor,
                        title: "MERN Stack",
                        percent: 0.9,
                      ),
                    ),
                    Container(
                      width: uiHelpers.width * 0.8,
                      child: LinearPercentIndicator(
                        progressColor: primaryColor,
                        title: "Python",
                        percent: 0.94,
                      ),
                    ),
                    Container(
                      width: uiHelpers.width * 0.8,
                      child: LinearPercentIndicator(
                        progressColor: primaryColor,
                        title: "Java",
                        percent: 0.84,
                      ),
                    ),
                    Container(
                      width: uiHelpers.width * 0.8,
                      child: LinearPercentIndicator(
                        progressColor: primaryColor,
                        title: "React JS",
                        percent: 0.84,
                      ),
                    ),
                    Container(
                      width: uiHelpers.width * 0.8,
                      child: LinearPercentIndicator(
                        progressColor: primaryColor,
                        title: "Open CV",
                        percent: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              uiHelpers.verticalSpaceMedium,
              Text(
                "Education",
                style: uiHelpers.title.copyWith(fontSize: 24),
              ),
              Container(
                width: uiHelpers.width * 0.26,
                child: Divider(
                  color: Colors.white60,
                  thickness: 2.5,
                ),
              ),
              Timeline(
                  indicatorColor: primaryColor,
                  lineColor: textSecondaryColor,
                  shrinkWrap: true,
                  itemGap: 25,
                  lineGap: 5,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "B.Tech (CSE)",
                            style: uiHelpers.title,
                          ),
                          SizedBox(height: 8),
                          Text("Sri Venkateswara University",
                              style: uiHelpers.body),
                          Text(
                            "2017 - 2021",
                            style: uiHelpers.body,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Intermediate (MPC)",
                            style: uiHelpers.title,
                          ),
                          SizedBox(height: 8),
                          Text("Sri Chaitanya Jr College",
                              style: uiHelpers.body),
                          Text(
                            "2015 - 2017",
                            style: uiHelpers.body,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SSC ",
                            style: uiHelpers.title,
                          ),
                          SizedBox(height: 8),
                          Text("Cattamanchi Ramalinga Reddy High School",
                              style: uiHelpers.body),
                          Text(
                            "2014 - 2015",
                            style: uiHelpers.body,
                          )
                        ],
                      ),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
