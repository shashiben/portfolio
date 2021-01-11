import 'package:flutter/material.dart';

class Experience {
  final String company;
  final String companyUrl;
  final String location;
  final String duration;
  final String position;
  final List<String> roles;

  Experience(
      {@required this.company,
      @required this.companyUrl,
      @required this.location,
      @required this.duration,
      @required this.position,
      @required this.roles});
}

List<Experience> experienceList = [
  Experience(
      company: "Naaniz",
      companyUrl: "Naaniz.org",
      location: "North India",
      duration: "45 Days",
      position: "Development Team lead",
      roles: ["backend developer", "front end", "third party "]),
  Experience(
      company: "Naaniz",
      companyUrl: "Naaniz.org",
      location: "North India",
      duration: "45 Days",
      position: "Development Team lead",
      roles: ["backend developer", "front end", "third party "]),
  Experience(
      company: "Naaniz",
      companyUrl: "Naaniz.org",
      location: "North India",
      duration: "45 Days",
      position: "Development Team lead",
      roles: ["backend developer", "front end", "third party "])
];
