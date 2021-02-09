import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';
import 'package:portfolio/core/utils/ScreenUtils.dart';

class ContactIconHeader extends StatelessWidget {
  final bool isActive;
  final String name;
  final Function onTap;
  final IconData icon;

  const ContactIconHeader(
      {Key key,
      this.isActive = false,
      @required this.onTap,
      @required this.name,
      @required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UIHelpers uiHelpers = UIHelpers.fromContext(context);
    return GestureDetector(
      onTap: ()=>onTap(),
          child: Material(
        color: Colors.transparent,
        elevation: isActive ? 10 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: isActive
              ? BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: primaryColor,
                    blurRadius: 5.0,
                  ),
                ], color: primaryColor, borderRadius: BorderRadius.circular(8))
              : BoxDecoration(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                name,
                style: uiHelpers.title.copyWith(fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ),
    );
  }
}
