import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';

class IconWrapper extends StatelessWidget {
  final Widget child;

  const IconWrapper({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: primaryColor.withOpacity(0.2)),
      child: child,
    );
  }
}
