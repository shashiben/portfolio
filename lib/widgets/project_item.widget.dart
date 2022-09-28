import 'package:flutter/material.dart';
import 'package:portfolio/core/models/project.model.dart';

class ProjectItem extends StatefulWidget {
  final Project project;
  const ProjectItem({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectItem> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Image.asset(
            widget.project.image,
            height: 250,
          )
        ],
      ),
    );
  }
}
