import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/contact%20me/contact_view_model.dart';
import 'package:portfolio/ui/widgets/contact_header_icon_widget.dart';
import 'package:portfolio/ui/widgets/fadeAnimation.dart';

class ContactDesktopView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final ContactViewModel model;

  const ContactDesktopView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FadeAnimation(xDistance:50,
                delay: 1.25,
                child: Text(
                  "Get In Touch!",
                  style: uiHelpers.headline.copyWith(fontSize: 45),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              FadeAnimation(xDistance:50,
                delay: 1.5,
                child: Text(
                  "Contact me for hiring,or help me to join your team",
                  style: uiHelpers.body.copyWith(fontSize: 25),
                ),
              ),
              uiHelpers.verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FadeAnimation(xDistance:50,
                    delay: 2,
                    child: MouseRegion(
                      onEnter: (event) => model.changeSelected(true, "Github"),
                      onExit: (event) => model.changeSelected(false, "Github"),
                      child: ContactIconHeader(
                        onTap: () =>
                            model.navigateToSocial(SocialLinks.githubLink),
                        name: "Github",
                        icon: ContactIcons.githubIcon,
                        isActive: model.selected == "Github",
                      ),
                    ),
                  ),
                  FadeAnimation(xDistance:50,
                    delay: 2.6,
                    child: MouseRegion(
                      onEnter: (event) => model.changeSelected(true, "Twitter"),
                      onExit: (event) => model.changeSelected(false, "Twitter"),
                      child: ContactIconHeader(
                        onTap: () =>
                            model.navigateToSocial(SocialLinks.twitterLink),
                        name: "Twitter",
                        icon: ContactIcons.twitterIcon,
                        isActive: model.selected == "Twitter",
                      ),
                    ),
                  ),
                  FadeAnimation(xDistance:50,
                    delay: 2.6,
                    child: MouseRegion(
                      onEnter: (event) =>
                          model.changeSelected(true, "LinkedIn"),
                      onExit: (event) =>
                          model.changeSelected(false, "LinkedIn"),
                      child: ContactIconHeader(
                        onTap: () =>
                            model.navigateToSocial(SocialLinks.linkedinUrl),
                        name: "LinkedIn",
                        icon: ContactIcons.linkedinIcon,
                        isActive: model.selected == "LinkedIn",
                      ),
                    ),
                  ),
                ],
              ),
              uiHelpers.verticalSpaceMedium,
              FadeAnimation(xDistance:50,
                delay: 2.8,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    width: uiHelpers.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact Form",
                          style: uiHelpers.headline,
                        ),
                        uiHelpers.verticalSpaceLow,
                        Row(
                          children: [
                            Container(
                              width: uiHelpers.width * 0.3,
                              child: Column(children: [
                                Text(
                                  "Your Name",
                                  style: uiHelpers.body,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                TextField(
                                  focusNode: model.focusNodeMap["name"],
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        FormIcon.nameIcon,
                                        color: model.hasFocusMap["name"]
                                            ? primaryColor
                                            : textPrimaryColor,
                                      ),
                                      hintText: "Luffy San",
                                      hintStyle:
                                          TextStyle(color: textPrimaryColor),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: textPrimaryColor)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: textSecondaryColor))),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Your Email",
                                  style: uiHelpers.body,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                TextField(
                                  focusNode: model.focusNodeMap["email"],
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        FormIcon.nameIcon,
                                        color: model.hasFocusMap["email"]
                                            ? primaryColor
                                            : textPrimaryColor,
                                      ),
                                      hintText: "youremail@gmail.com",
                                      hintStyle:
                                          TextStyle(color: textPrimaryColor),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: textPrimaryColor)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: textSecondaryColor))),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Subject",
                                  style: uiHelpers.body,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                TextField(
                                  focusNode: model.focusNodeMap["subject"],
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        FormIcon.nameIcon,
                                        color: model.hasFocusMap["subject"]
                                            ? primaryColor
                                            : textPrimaryColor,
                                      ),
                                      hintText: "Hiring for...",
                                      hintStyle:
                                          TextStyle(color: textPrimaryColor),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: textPrimaryColor)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: textSecondaryColor))),
                                ),
                              ], crossAxisAlignment: CrossAxisAlignment.start),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Message",
                                      style: uiHelpers.body,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    TextFormField(
                                      maxLines: 10,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                  color: textPrimaryColor)),
                                          alignLabelWithHint: true,
                                          hintStyle: TextStyle(
                                              color: textPrimaryColor),
                                          hintText: "Your Messsage..",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                  color: textSecondaryColor))),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        uiHelpers.verticalSpaceHigh,
                        Container(
                          alignment: Alignment.center,
                          child: MaterialButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              color: primaryColor,
                              onPressed: () {},
                              child: Text(
                                "Send Message",
                                style: uiHelpers.buttonStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
          ),
        ),
      ),
    );
  }
}
