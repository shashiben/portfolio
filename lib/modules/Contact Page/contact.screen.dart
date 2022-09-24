import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:flutter_next/utils/shadows/next_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/widgets/components/custom_textfield.widget.dart';

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
              children: const [
                Text("CONTACT ME"),
                Text("Let's talk about project/oppurtunity"),
                
              ],
            ),
          ),
          NextCol(
              sizes: 'col-12 col-md-6',
              child: Center(
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 25,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: NextShadow.shadow400(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Send me a message"),
                      CustomTextField(
                        title: "Name",
                        controller: TextEditingController(),
                      ),
                      CustomTextField(
                        title: "Email",
                        controller: TextEditingController(),
                      ),
                      CustomTextField(
                        title: "Subject",
                        controller: TextEditingController(),
                      ),
                      CustomTextField(
                        title: "Message",
                        controller: TextEditingController(),
                        maxLines: 5,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(FontAwesomeIcons.share),
                        onPressed: () {},
                        label: const Text(
                          "Send",
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ])
      ],
    );
  }
}
