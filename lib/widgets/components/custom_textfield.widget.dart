import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLines;
  final String title;
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.maxLines = 1,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: title,
            alignLabelWithHint: true,
          ),
          maxLines: maxLines,
          controller: controller,
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
