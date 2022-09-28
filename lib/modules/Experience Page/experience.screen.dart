import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/app/constants/data/experience.data.dart';

import '../../widgets/company.item.dart';

class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Experience 💼",
          style: GoogleFonts.breeSerif(
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return CompanyItem(
              company: experienceList[index],
              isReverse: index % 2 != 0,
            );
          },
          itemCount: experienceList.length,
        )
      ],
    );
  }
}
