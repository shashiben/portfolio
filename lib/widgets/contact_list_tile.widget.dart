import 'package:flutter_next/flutter_next.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactListTile extends StatelessWidget {
  final String title, subtitle;
  final IconData leadingIcon;
  const ContactListTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.leadingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      builder: (BuildContext context, bool isHovered) => Row(
        children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: isHovered
                      ? context.primaryColor
                      : context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.all(8),
              child: Icon(
                leadingIcon,
                size: 20,
                color: isHovered ? Colors.white : context.primaryColor,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.breeSerif(
                    fontSize: 18,
                    color: context.primaryColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle,
                style: TextStyle(
                    color: context.primaryColor, fontWeight: FontWeight.w400),
              )
            ],
          ).container(padding: const EdgeInsets.only(left: 15)),
        ],
      ),
    ).container(padding: const EdgeInsets.only(bottom: 40));
  }
}
