import 'package:flutter/material.dart';

class Role extends StatelessWidget {
  Role({
    @required this.role,
    this.roleTextStyle,
    this.icon = Icons.arrow_right,
    this.iconSize = 18,
  });

  final String role;
  final TextStyle roleTextStyle;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Color(0xffCCD7F5),
        ),
        SizedBox(height: 10),
        Expanded(
          child: Text(
            role,
            style: roleTextStyle ??
                theme.textTheme.bodyText1.copyWith(
                  color: Color(0xff75809C),
                ),
          ),
        ),
      ],
    );
  }
}
