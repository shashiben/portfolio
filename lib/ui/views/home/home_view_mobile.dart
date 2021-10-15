import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../app/configs.dart';
import '../../../app/icons.dart';
import '../../../core/utils/ScreenUiHelper.dart';
import '../../widgets/icon_wrapper.dart';

import 'home_view_model.dart';

class HomeMobileView extends StatelessWidget {
  final ScreenUiHelper? uiHelpers;
  final HomeViewModel? model;

  const HomeMobileView({Key? key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiHelpers!.backgroundColor,
      body: Container(
          width: uiHelpers!.width,
          height: uiHelpers!.height,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/sk_logo.png',
                    height: 40, width: 40, color: uiHelpers!.textPrimaryColor),
                IconWrrapper(
                  margin: const EdgeInsets.all(0),
                  color: uiHelpers!.primaryColor,
                  padding: const EdgeInsets.all(8),
                  onTap: () =>
                      model!.navigateToUrl('mailto:' + PersonalDetails.email),
                  child: const Icon(
                    MenuIcons.contactIcon,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Portfolio',
              style: uiHelpers!.body,
            ),
            const SizedBox(height: 8),
            Text(
              "Hello,I'm",
              style: uiHelpers!.headline,
            ),
            Text(
              'Shashi Kumar',
              style: uiHelpers!.headline,
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
                height: 175.0,
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                      autoPlayCurve: Curves.easeOutQuart,
                      autoPlay: true,
                      viewportFraction: 1),
                  itemCount: PersonalDetails.skillDisplayList.length,
                  itemBuilder: (_, index, realIndex) {
                    return Container(
                      width: uiHelpers!.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                          color: PersonalDetails.skillDisplayList[index].color,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            PersonalDetails.skillDisplayList[index].iconData,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            PersonalDetails.skillDisplayList[index].title!,
                            style: uiHelpers!.title!.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: SystemProperties.fontName),
                          ),
                        ],
                      ),
                    );
                  },
                )),
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              IconWrrapper(
                margin: const EdgeInsets.all(0),
                color: uiHelpers!.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                onTap: () => model!.navigateToUrl(PersonalDetails.whatsappLink),
                child: Text(
                  'Contact',
                  style: uiHelpers!.buttonStyle!.copyWith(color: Colors.white),
                ),
              ),
              IconWrrapper(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                onTap: () => model!.navigateToUrl(PersonalDetails.resumeLink),
                child: Text(
                  'Download CV',
                  style: uiHelpers!.buttonStyle,
                ),
              )
            ]),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/business.png',
                ),
              ),
            ),
          ])),
    );
  }
}
