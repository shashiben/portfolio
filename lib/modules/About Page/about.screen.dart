import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/app/constants/data/my_info.data.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me 😎',
          style: GoogleFonts.breeSerif(
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        NextRow(children: [
          const NextCol(
            sizes: 'col-12 col-md-5',
            child: SizedBox(),
          ),
          NextCol(
            sizes: 'col-12 col-md-7',
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'I am ${MYInfo.name}, a Senior software developer from India.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(MYInfo.educationDetails),
              const SizedBox(
                height: 15,
              ),
              Text(MYInfo.aboutBodyText1),
              const SizedBox(
                height: 25,
              ),
              NextButton(
                borderRadius: BorderRadius.circular(0),
                onPressed: () {},
                color: Colors.white,
                variant: NextButtonVariant.outlined,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Resume 📁"),
                ),
              )
            ]),
          )
        ]),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }
}
