import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/app/icons.dart';
import 'package:get/get.dart';
import 'package:stacked_services/stacked_services.dart';

import 'locator.dart';

enum SnackbarType { floating }
void setupSnackbarUi() {
  final service = locator<SnackbarService>();
  service.registerCustomSnackbarConfig(
    variant: SnackbarType.floating,
    config: SnackbarConfig(
      margin: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 20),
      messageColor: Colors.white70,
      icon: Icon(
        ToastIcons.successIcon,
        color: successColor,
      ),
      backgroundColor: primaryColor,
      mainButtonTextColor: successColor,
      padding: const EdgeInsets.all(12).copyWith(top: 15),
      textColor: Colors.white,
      overlayBlur: 2,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      barBlur: 2,
      boxShadows: [BoxShadow(color: primaryColor)],
      animationDuration: Duration(seconds: 2),
      borderRadius: 10,
      dismissDirection: SnackDismissDirection.VERTICAL,
    ),
  );
}
