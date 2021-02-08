import 'package:portfolio/core/models/project.dart';
import 'package:portfolio/core/models/skill_model.dart';

//*Social Media Links
class SocialLinks {
  static String linkedinUrl =
      "https://www.linkedin.com/in/shashi-kumar-58ab1b1a4/";
  static String mediumLink = "https://medium.com/@ben75930";
  static String twitterLink = "https://twitter.com/Shashi35744438";
  static String githubLink = "https://github.com/shashiben";
}

//*System Defaults
class SystemProperties {
  static String fontName = "Inter";
}

//*Personal details
class PersonalDetails {
  static String email = "kumarshashi5294@gmail.com";
  static List<SkillModel> skillList = [
    SkillModel(name: "Python", percent: 90),
    SkillModel(name: "Java", percent: 80),
    SkillModel(name: "C", percent: 70),
    SkillModel(name: "Node js", percent: 80),
    SkillModel(name: "Flutter", percent: 90),
    SkillModel(name: "Javascript", percent: 80)
  ];

  static List<Project> projectsList = [
    Project(tools: [], title: "", description: "")
  ];

  static String userName = "Shashi Kumar";
  static String shortIntro = "";
  static String intro = "";
}

//*Education Details
class EducationDetails {
  static String collegeName = "";
  static String collegeTimeline = "";
  static String schoolName = "";

  static String schoolTimeline = "";
  static String universityName = "";
  static String universityTimeline = "";

  static String collegeBranch = "CSE";
  static String collegeStream = "MPC";
}
