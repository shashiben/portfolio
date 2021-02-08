import 'package:flutter/material.dart';

class Project {
  final String githubLink;
  final String websiteLink;
  final String playstoreLink;
  final String title;
  final String description;
  final List<String> tools;

  Project(
      {this.githubLink,
      this.websiteLink,
      this.playstoreLink,
      @required this.title,
      @required this.description,
      @required this.tools});
}
