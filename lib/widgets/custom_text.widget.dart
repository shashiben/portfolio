import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final Map<String, TextStyle> textMap;
  final String text;
  final TextStyle? style;
  const CustomText({
    Key? key,
    this.textMap = const {},
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> buildTextSpan() {
      List<TextSpan> result = [];
      text.split(' ').forEach((element) {
        if (element.startsWith('[') && element.endsWith(']')) {
          String key = element[1];
          String text =
              element.substring(3, element.length - 1).replaceAll("%20", " ");
          result.add(TextSpan(
            text: "$text ",
            style: textMap[key] ?? style,
          ));
        } else {
          result.add(TextSpan(
            text: "$element ",
            style: style,
          ));
        }
      });
      return result;
    }

    return Text.rich(
      TextSpan(children: buildTextSpan()),
      style: style,
    );
  }
}
