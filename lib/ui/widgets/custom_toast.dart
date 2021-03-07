import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';

class CustomToast extends StatelessWidget {
  final String content;
  final Icon icon;
  const CustomToast({@required this.content, @required this.icon});

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      shadowColor: Colors.transparent,
      color: backgroundColor,
      elevation: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: 500,
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(
                width: 5,
              ),
              Text(
                content,
                style: uiHelper.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
