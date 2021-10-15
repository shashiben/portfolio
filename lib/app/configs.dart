import 'package:flutter/material.dart';

import '../core/models/project.dart';
import '../core/models/skill_display.dart';
import '../core/models/skill_model.dart';
import '../core/models/technologies.dart';
import '../core/models/timeline_experience.dart';
import 'icons.dart';

//*Social Media Links
mixin SocialLinks {
  static const String linkedinUrl =
      'https://www.linkedin.com/in/shashi-kumar-58ab1b1a4/';
  static const String mediumLink = 'https://medium.com/@ben75930';
  static const String twitterLink = 'https://twitter.com/Shashi35744438';
  static const String githubLink = 'https://github.com/shashiben';
  static const String facebookLink = 'https://www.facebook.com/shashiben7997';
  static const String instagramLink =
      'https://www.instagram.com/shashikumar7997/';
  static const String telegramLink = 'https://t.me/shashiben';
}

//*System Defaults
mixin SystemProperties {
  static const String fontName = 'Montserrat';
  static const String titleFont = 'Lato';
}

//*Education Details
mixin EducationDetails {
  static const String collegeName = 'Sri Chaitanya Jr College';
  static const String collegeTimeline = '2015 - 2017';
  static const String schoolName = 'Cattamanchi Ramalinga Reddy High School';

  static const String schoolTimeline = '2014 - 2015';
  static const String universityName = 'Sri Venkateswara University';
  static const String universityTimeline = '2017 - 2021';

  static const String universityStream = 'Computer Science and Engineering';
  static const String schoolStream = 'SSC';
  static const String collegeStream = 'Intermediate (MPC)';

  static const double universityPercentage = 75.4;
  static const double schoolPercentage = 95.2;
  static const double collegePercentage = 93;
}

//*Personal details
mixin PersonalDetails {
  static const List<SkillDisplay> skillDisplayList = [
    SkillDisplay(
        title: 'Mobile Application Developement',
        color: Color(0xFFE2A599),
        iconData: SkillDisplayIcons.appIcon),
    SkillDisplay(
        title: 'Full Stack Web Developement',
        color: Color(0xFF5E57BB),
        iconData: SkillDisplayIcons.websiteIcon),
    SkillDisplay(
        title: 'AI/ML Engineering',
        color: Color(0xFFE45447),
        iconData: SkillDisplayIcons.mlIcon),
    SkillDisplay(
        title: 'Database Management',
        color: Color(0xFFFFB300),
        iconData: SkillDisplayIcons.databaseIcon)
  ];
  static const String resumeLink =
      'https://drive.google.com/file/d/1zgGpQfz1sgvG-8eiCDXzmBIu59mJ7Jho/view?usp=sharing';
  static const String whatsappLink = 'https://wa.me/7997217156';
  static const List<Technologies> techList = [
    Technologies(icon: TechnologiesIcon.reactJsIcon, name: 'React JS'),
    Technologies(icon: TechnologiesIcon.javaIcon, name: 'Java'),
    Technologies(icon: TechnologiesIcon.pythonIcon, name: 'Python')
  ];
  static const String githubUserName = 'shashiben';
  static const String githubDataUrl =
      'https://api.github.com/users/$githubUserName/repos';
  static List<Project> projectsList = [
    Project(
        id: '0',
        type: ['Website'],
        title: 'Hostel Management',
        githubLink: 'https://github.com/shashiben/Hostel-Management',
        websiteLink: 'https://hostel-app-test.herokuapp.com/login',
        description:
            'Created a hostel management web app to track students where they are, and download data of attendance for each day',
        tools: ['Redux', 'Node Js', 'Express Js', 'Mongo DB', 'React Js']),
    Project(
        id: '1',
        type: ['Website'],
        title: 'E Commerce',
        githubLink: 'https://github.com/shashiben/MERN-ECommerce',
        websiteLink: 'https://nsd-solutions.herokuapp.com/',
        description:
            'An ECommerce application similar to amazon or flipkart where users can buy products,contains admin panel',
        tools: ['Redux', 'Node Js', 'Express Js', 'Mongo DB', 'React Js']),
    Project(
        id: '2',
        type: ['Application'],
        title: 'Flutter Custom Graph',
        githubLink: 'https://github.com/shashiben/flutter_custom_graph',
        description:
            'Created a flutter package for building customized and aesthetic graphs.Built with the help of custom graphs.',
        tools: ['Flutter']),
    Project(
        id: '3',
        type: ['Application'],
        title: 'Face Mask Detection',
        githubLink: 'https://github.com/shashiben/flutter-face-mask-detection',
        description:
            'Mobile Application to detect whether person wears a mask or not.Built with Flutter and tensorflow lite.',
        tools: ['Flutter', 'Tflite', 'CNN', 'Python']),
    Project(
        id: '4',
        type: ['Website'],
        title: 'FReMP Stack',
        githubLink: 'https://github.com/shashiben/FReMP-Stack',
        description:
            'Created a simple application to show how to perform crud operations using flask,react and mongo db and includes how to search by name.',
        tools: ['Flask', 'React', 'Mongo DB', 'Python']),
    Project(
        id: '5',
        type: ['Opencv'],
        title: 'Motion Detection Using OpenCv',
        githubLink: 'https://github.com/shashiben/Motion-Detection-with-Opencv',
        description:
            'Detects motion of an object or a person and draws bounding box over it',
        tools: ['Python', 'OpenCv']),
    Project(
        id: '6',
        type: ['Website', 'Application'],
        title: 'Alarm Managaer',
        githubLink: 'https://github.com/shashiben/Flutter-Alarm',
        description:
            'An application to schedule alarms on multiple devices supports for both android and ios,built using mongo db and flutter.',
        tools: ['Flutter', 'Mongo DB', 'Node Js', 'Express Js']),
    Project(
        id: '7',
        type: ['Application', 'Website'],
        title: 'Cache With Hive',
        githubLink: 'https://github.com/shashiben/Flutter-anime',
        description:
            'Application which shows how to cache rest api data,so that user can view data even though he is offline.Presently supports for web, android and ios',
        tools: ['Flutter', 'Hive']),
    Project(
        id: '8',
        type: ['Application'],
        title: 'College Fest App',
        playstoreLink:
            'https://play.google.com/store/apps/details?id=com.cse.cynosure',
        githubLink: 'https://github.com/shashiben/College-Fest-app',
        description:
            'Created an app for college fest where users can register for events and get live notifications regarding events and has payment gateway integration.',
        tools: ['Java', 'Firebase', 'Paytm']),
    Project(
        id: '9',
        type: ['Website', 'Application'],
        websiteLink: 'https://shashiben.github.io',
        description:
            'Created portfolio using flutter,Supports for mac os,windows,linux,web,ios,android',
        githubLink: 'https://github.com/shashiben/portfolio',
        title: 'Portfolio',
        tools: ['Flutter']),
    Project(
        id: '10',
        type: ['Backend'],
        title: 'Node Mailer',
        githubLink: 'https://github.com/shashiben/node-mailer',
        description:
            'Backend for sending mails.Used to add functionality of sending mail without opening any other applications',
        tools: ['Node JS', 'Email JS', 'Express JS'])
  ];
  static const List<String> skillsList = [
    'Flutter',
    'MERN Stack',
    'FReMP Stack',
    'Git',
    'Firebase',
    'Java Developer',
    'Open Cv',
    'OOPS',
    'C',
    'Python',
    'Flask',
    'Problem Solving',
  ];

  static const List<ExperienceTimeline> experienceList = [
    ExperienceTimeline(
        title: 'TopRecur',
        position: 'Internship',
        timePeriod: 'Jan 2021 - Feb 2021',
        description: [
          'Worked as an intern for mobile app developement and front end developer',
          'Application is similar to Workflowy for note taking',
          'Added export service of all the data present in the parent node',
          'Added Functionality to customize text styling dynamically'
        ],
        tools: [
          'Flutter',
          'Html',
          'Css',
          'JS',
          'React',
          'Flask',
          'Celery',
          'Mongo DB'
        ]),
    ExperienceTimeline(
        title: 'ITI Hindupur',
        position: 'Freelancer',
        timePeriod: 'Dec 2020 - Jan 2021',
        description: [
          'Developed UI for ITI Hindupur and developed mobile application',
          'Designed Admin Panel to send notifications or add notes or create tests',
          'Designed College Application to create quiz for different batches',
          'Able to add or delete or update notes',
          'Added Contact Support using Freshchat',
          'Can check analysis of his previous test'
        ],
        tools: [
          'Flutter',
          'Firebase',
          'FreshChat',
          'Figma'
        ]),
    ExperienceTimeline(
        title: 'Tefso',
        position: 'Mobile App Developer',
        timePeriod: 'Aug 2020 - Sep 2021',
        description: [
          'Worked collaboratively with designer to bring mobile app to life',
          'Developed UI for application similar to doubtnut',
          'Created frontend application to check user profile and quiz',
          'Added voice support for adding questions',
          'Designed UI for asking doubts or to check others questions.',
        ],
        tools: [
          'Flutter',
          'Figma'
        ]),
    ExperienceTimeline(
      tools: ['Firebase', 'DialogFlow', 'Agora', 'GCP', 'Node js', 'Mongo'],
      timePeriod: 'May 2020 - July 2020',
      title: 'Naaniz',
      position: 'Developement Team Lead',
      description: [
        'Managing a team of 25 members, able to divide and assign works to them',
        'Designed DB Schema and made the UI of the app responsive',
        'Integrated Payment Gateway Integration (Razorpay)',
        'Implemented Video Broadcasting feature,Chat bot,Voice Search'
      ],
    ),
  ];
  static const String email = 'kumarshashi5294@gmail.com';
  static List<SkillModel> featuredSkills = [
    SkillModel(name: 'Mobile Application Developement', percent: 95),
    SkillModel(name: 'Web Developer', percent: 90),
    SkillModel(name: 'UI/UX Designer', percent: 84),
    SkillModel(name: 'Backend Developer', percent: 89),
  ];

  static const String userName = 'Shashi Kumar';
  static const String shortIntro =
      'I’m Shashi Kumar and I’m a full stack developer, and I specialize in building efficient Flutter Applications that just work across all platforms and browsers. I care deeply about building interfaces that are usable and pleasant for the most number of people possible.And my main motto is whenever building any application is to always build pixel perfect high performant applications that provide user with a rich experience.';
  static const String intro =
      "I started my career into developement as android developer.First I built android applications in native android.Later I heared about flutter which helps in building cross platform applications.After gaining experience in flutter,I applied to internships,through which I was able to learn communication skills and code architectures.After that I worked as a freelancer and gained experience of how to build applications in production level.Presently I'm focusing on web developement.I learnt MERN Stack.And working projects on it.";
}
