import 'package:flutter/cupertino.dart';

class NavBarItem {
  final Widget? child;
  final void Function()? onTap;
  final String title;

  NavBarItem({
    this.child,
    this.onTap,
    this.title = '',
  });
}
