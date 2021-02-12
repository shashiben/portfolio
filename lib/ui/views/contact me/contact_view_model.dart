import 'package:flutter/cupertino.dart';
import 'package:portfolio/core/services/url_launcher_service.dart';
import 'package:stacked/stacked.dart';

class ContactViewModel extends BaseViewModel {
  final UrlLauncherService _urlLauncherService = UrlLauncherService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  openMail() async {
    if (formKey.currentState.validate()) {
      String subject = "From ${nameController.text}:${subjectController.text}";
      String url =
          'mailto:${emailController.text}?subject=$subject&body=${bodyController.text}';
      await _urlLauncherService.launchUrl(url);
    }
  }

  Map<String, FocusNode> focusNodeMap = {
    "name": FocusNode(),
    "email": FocusNode(),
    "subject": FocusNode()
  };
  Map<String, bool> hasFocusMap = {
    "name": false,
    "email": false,
    "subject": false
  };
  String selected;
  changeSelected(bool active, String name) {
    if (active) {
      selected = name;
      notifyListeners();
    } else {
      selected = null;
      notifyListeners();
    }
  }

  navigateToSocial(String url) async {
    await _urlLauncherService.launchUrl(url);
  }

  init() {
    focusNodeMap["name"].addListener(() {
      hasFocusMap["name"] = focusNodeMap["name"].hasFocus;
      notifyListeners();
    });
    focusNodeMap["email"].addListener(() {
      hasFocusMap["email"] = focusNodeMap["email"].hasFocus;
      notifyListeners();
    });
    focusNodeMap["subject"].addListener(() {
      hasFocusMap["subject"] = focusNodeMap["subject"].hasFocus;
      notifyListeners();
    });
  }
}
