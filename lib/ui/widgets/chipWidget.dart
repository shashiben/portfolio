import 'package:flutter/material.dart';
import 'package:portfolio/app/colors.dart';

class ChipWidget extends StatelessWidget {
  final String text;
  final bool isSelected;

  const ChipWidget({Key key, this.text, this.isSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: isSelected
            ? TextStyle(
                decoration: TextDecoration.none,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textPrimary)
            : TextStyle(
                decoration: TextDecoration.none,
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: textPrimary),
      ),
    );
  }
}
