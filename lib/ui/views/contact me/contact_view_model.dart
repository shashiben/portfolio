import 'package:flutter/cupertino.dart';
import 'package:portfolio/core/services/url_launcher_service.dart';
import 'package:stacked/stacked.dart';

class ContactViewModel extends BaseViewModel {
  final UrlLauncherService _urlLauncherService=UrlLauncherService();
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

  navigateToSocial(String url)async{
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
