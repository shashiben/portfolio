import 'package:portfolio/core/models/project.dart';
import 'package:portfolio/core/models/skill_model.dart';
import 'package:portfolio/core/models/timeline_experience.dart';
import 'package:flutter/material.dart';

//*Social Media Links
mixin SocialLinks {
  static String linkedinUrl =
      "https://www.linkedin.com/in/shashi-kumar-58ab1b1a4/";
  static String mediumLink = "https://medium.com/@ben75930";
  static String twitterLink = "https://twitter.com/Shashi35744438";
  static String githubLink = "https://github.com/shashiben";
}

//*System Defaults
mixin SystemProperties {
  static String fontName = "Montserrat";
  static String titleFont = "Lato";
}

//*Personal details
mixin PersonalDetails {
  static List<Project> projectsList = [
    Project(
        title: "Hostel Management",
        description:
            "Created a hostel management web app to track students where they are,and note down the attendance of students according to room No and download data of attendance for each day",
        tools: ["Redux", "Node Js", "Express Js", "Mongo DB", "React Js"]),
    Project(
        title: "E Commerce",
        description:
            "An ECommerce application similar to amazon or flipkart where users can buy products,contains admin panel",
        tools: ["Redux", "Node Js", "Express Js", "Mongo DB", "React Js"]),
    Project(
        title: "Face Mask Detection",
        description:
            "Mobile Application to detect whether person wears a mask or not.Built with Flutter and tensorflow lite.",
        tools: ["Flutter", "Tflite", "CNN", "Python"]),
    Project(
        title: "Motion Detection Using OpenCv",
        description:
            "Detects motion of an object or a person and draws bounding box over it",
        tools: ["Python", "OpenCv"])
  ];
  static List<String> skillsList = [
    "Flutter",
    "MERN Stack",
    "FReMP Stack",
    "Git",
    "Firebase",
    "Java Developer",
    "Open Cv",
    "OOPS",
    "C",
    "Python",
    "Flask",
    "Problem Solving",
  ];

  static List<ExperienceTimeline> experienceList = [
    ExperienceTimeline(
      tools: ["Firebase", "DialogFlow", "Agora", "GCP", "Node js", "Mongo"],
      timePeriod: "May 2020 - July 2020",
      title: "Naaniz",
      position: "Developement Team Lead",
      description: [
        "Managing a team of 25 members, able to divide and assign works to them",
        "Designed DB Schema and made the UI of the app responsive",
        "Integrated Payment Gateway Integration (Razorpay)",
        "Implemented Video Broadcasting feature,Chat bot,Voice Search"
      ],
      child: Image.asset("assets/images/naaniz.png", height: 60, width: 40),
    ),
    ExperienceTimeline(
      tools: ["Firebase", "DialogFlow", "Agora", "GCP", "Node js", "Mongo"],
      timePeriod: "July 2020 - Aug 2020",
      title: "Naaniz",
      position: "Developement Team Lead",
      description: [
        "Managing a team of 25 members, able to divide and assign works to them",
        "Designed DB Schema and made the UI of the app responsive",
        "Integrated Payment Gateway Integration (Razorpay)",
        "Added Video Broadcasting feature"
      ],
      child: Image.asset("assets/images/naaniz.png", height: 60, width: 40),
    ),
    ExperienceTimeline(
      tools: ["Firebase", "DialogFlow", "Agora", "GCP", "Node js", "Mongo"],
      timePeriod: "May 2020 - July 2020",
      title: "Naaniz",
      position: "Developement Team Lead",
      description: [
        "Managing a team of 25 members, able to divide and assign works to them",
        "Designed DB Schema and made the UI of the app responsive",
        "Integrated Payment Gateway Integration (Razorpay)",
        "Implemented Video Broadcasting feature,Chat bot,Voice Search"
      ],
      child: Image.asset("assets/images/naaniz.png", height: 60, width: 40),
    ),
    ExperienceTimeline(
      tools: ["Firebase", "DialogFlow", "Agora", "GCP", "Node js", "Mongo"],
      timePeriod: "July 2020 - Aug 2020",
      title: "Naaniz",
      position: "Developement Team Lead",
      description: [
        "Managing a team of 25 members, able to divide and assign works to them",
        "Designed DB Schema and made the UI of the app responsive",
        "Integrated Payment Gateway Integration (Razorpay)",
        "Added Video Broadcasting feature"
      ],
      child: Image.asset("assets/images/naaniz.png", height: 60, width: 40),
    )
  ];
  static String email = "kumarshashi5294@gmail.com";
  static List<SkillModel> featuredSkills = [
    SkillModel(name: "Mobile Application Developement", percent: 90),
    SkillModel(name: "Web Developer", percent: 80),
    SkillModel(name: "UI/UX Designer", percent: 75),
    SkillModel(name: "Backend Developer", percent: 80),
  ];

  static String userName = "Shashi Kumar";
  static String shortIntro =
      "A dexterous builder for mobile and web application.";
  static String intro =
      "A Full stack developer from Andhra Pradesh,India. Intrested in building mobile applications and web applications with flutter . Recently started developing web apps with react. And had a little knowledge in Opencv.";
}

//*Education Details
mixin EducationDetails {
  static String collegeName = "Sri Chaitanya Jr College";
  static String collegeTimeline = "2015 - 2017";
  static String schoolName = "Cattamanchi Ramalinga Reddy High School";

  static String schoolTimeline = "2014 - 2015";
  static String universityName = "Sri Venkateswara University";
  static String universityTimeline = "2017 - 2021";

  static String universityStream = "B.Tech (CSE)";
  static String schoolStream = "SSC";
  static String collegeStream = "Intermediate (MPC)";
}
