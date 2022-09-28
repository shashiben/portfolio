import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/widgets/components/custom_textfield.widget.dart';

import '../../widgets/contact_list_tile.widget.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      children: [
        NextRow(children: [
          NextCol(
            sizes: 'col-12 col-md-6',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CONTACT ME💬",
                  style: GoogleFonts.breeSerif(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text("Let's talk about project/oppurtunity"),
                const SizedBox(
                  height: 30,
                ),
                const ContactListTile(
                    title: 'Location:',
                    subtitle: 'Kurnool,Andhra Pradesh,518001',
                    leadingIcon: FontAwesomeIcons.locationArrow),
                const ContactListTile(
                    title: 'Email:',
                    subtitle: 'kumarshashi5294@gmail.com',
                    leadingIcon: Icons.email_outlined),
                const ContactListTile(
                    title: 'Call:',
                    subtitle: '+91-797217156',
                    leadingIcon: Icons.mobile_friendly_rounded)
              ],
            ),
          ),
          NextCol(
              sizes: 'col-12 col-md-6',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Send me a message",
                    style: GoogleFonts.breeSerif(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                            keyboardType: TextInputType.name,
                            controller: TextEditingController(),
                            title: 'Your name'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: CustomTextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: TextEditingController(),
                            title: 'Your Email'),
                      )
                    ],
                  ),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    controller: TextEditingController(),
                    title: 'Subject',
                  ),
                  CustomTextField(
                      keyboardType: TextInputType.multiline,
                      controller: TextEditingController(),
                      title: 'Message',
                      maxLines: 4),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(FontAwesomeIcons.share),
                    onPressed: () {},
                    label: const Text(
                      "Send",
                    ),
                  )
                ],
              ))
        ]),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }
}
