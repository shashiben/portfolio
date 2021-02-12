import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/ui/views/contact%20me/contact_view_model.dart';
import 'package:portfolio/ui/widgets/fadeAnimation.dart';

class ContactMobileView extends StatelessWidget {
  final ScreenUiHelper uiHelpers;
  final ContactViewModel model;

  const ContactMobileView({Key key, this.uiHelpers, this.model})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                uiHelpers.verticalSpaceMedium,
                Text(
                  "Get In Touch!",
                  style: uiHelpers.headline.copyWith(fontSize: 24),
                ),
                SizedBox(
                  height: 8,
                ),
                FadeAnimation(
                  xDistance: 30,
                  delay: 1.5,
                  child: Text(
                    "Contact me for hiring,or help me to join your team",
                    style: uiHelpers.body.copyWith(fontSize: 18),
                  ),
                ),
                uiHelpers.verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FadeAnimation(
                      xDistance: 30,
                      delay: 2,
                      child: IconButton(
                        icon: Icon(ContactIcons.githubIcon),
                        onPressed: () =>
                            model.navigateToSocial(SocialLinks.githubLink),
                      ),
                    ),
                    FadeAnimation(
                      xDistance: 30,
                      delay: 2.4,
                      child: IconButton(
                        icon: Icon(ContactIcons.twitterIcon),
                        onPressed: () =>
                            model.navigateToSocial(SocialLinks.twitterLink),
                      ),
                    ),
                    FadeAnimation(
                      xDistance: 30,
                      delay: 2.8,
                      child: IconButton(
                        icon: Icon(ContactIcons.linkedinIcon),
                        onPressed: () =>
                            model.navigateToSocial(SocialLinks.linkedinUrl),
                      ),
                    )
                  ],
                ),
                uiHelpers.verticalSpaceMedium,
                FadeAnimation(
                  xDistance: 30,
                  delay: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Form",
                        style: uiHelpers.title,
                      ),
                      uiHelpers.verticalSpaceLow,
                      Column(children: [
                        Text(
                          "Your Name",
                          style: uiHelpers.body,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: model.nameController,
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return "Please Enter Name";
                            }

                            return null;
                          },
                          focusNode: model.focusNodeMap["name"],
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(
                                FormIcon.nameIcon,
                                color: model.hasFocusMap["name"]
                                    ? primaryColor
                                    : textPrimaryColor,
                              ),
                              hintText: "Luffy San",
                              hintStyle: TextStyle(color: textPrimaryColor),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textPrimaryColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textSecondaryColor))),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Your Email",
                          style: uiHelpers.body,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return "Please Enter Email";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                .hasMatch(value)) {
                              return "Please enter valid email";
                            }

                            return null;
                          },
                          controller: model.emailController,
                          focusNode: model.focusNodeMap["email"],
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(
                                FormIcon.nameIcon,
                                color: model.hasFocusMap["email"]
                                    ? primaryColor
                                    : textPrimaryColor,
                              ),
                              hintText: "youremail@gmail.com",
                              hintStyle: TextStyle(color: textPrimaryColor),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textPrimaryColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textSecondaryColor))),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Subject",
                          style: uiHelpers.body,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: model.subjectController,
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return "Please Enter Subject";
                            }

                            return null;
                          },
                          focusNode: model.focusNodeMap["subject"],
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(
                                FormIcon.nameIcon,
                                color: model.hasFocusMap["subject"]
                                    ? primaryColor
                                    : textPrimaryColor,
                              ),
                              hintText: "Hiring for...",
                              hintStyle: TextStyle(color: textPrimaryColor),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textPrimaryColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textSecondaryColor))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Message",
                          style: uiHelpers.body,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: model.bodyController,
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return "Please Enter Message";
                            }

                            return null;
                          },
                          maxLines: 4,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textPrimaryColor)),
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(color: textPrimaryColor),
                              hintText: "Your Messsage..",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: textSecondaryColor))),
                        ),
                      ], crossAxisAlignment: CrossAxisAlignment.start),
                      uiHelpers.verticalSpaceMedium,
                      Container(
                        alignment: Alignment.center,
                        child: MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            color: primaryColor,
                            onPressed: () => model.openMail(),
                            child: Text(
                              "Send Message",
                              style: uiHelpers.buttonStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                      uiHelpers.verticalSpaceMedium,
                    ],
                  ),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
            ),
          ),
        ),
      ),
    );
  }
}
