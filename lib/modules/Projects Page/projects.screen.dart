import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/app/constants/data/projects.data.dart';
import 'package:portfolio/widgets/project_item.widget.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextContainer(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Projects 👨‍💻',
          style: GoogleFonts.breeSerif(
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        NextRow(
            children: projectsList
                .map((e) => NextCol(
                      sizes: 'col-12 col-xxl-4 col-lg-4 col-md-6',
                      child: ProjectItem(project: e),
                    ))
                .toList()),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }
}
