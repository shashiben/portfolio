import 'package:portfolio/core/models/company.model.dart';
import 'package:portfolio/gen/assets.gen.dart';

List<Company> experienceList = [
  Company(
      name: "Webknot Technologies Pvt Ltd.",
      period: "May 2021 - Present",
      points: [
        "Awarded [b'MVP] in May 2021 and [b'Spot%20Award] in October 2021.",
        'Worked on android KIOSK device config, payment gateway integration,flutter method channels.',
        'Mentored intermediate and junior developers by sharing knowledge of best practices, standards and experiences, while removing roadblocks/challenges.',
        'Responsible for building responsive applications across all platforms in flutter.'
      ],
      image: Assets.images.company.webknot.path),
  Company(
      name: "Naaniz",
      period: "May 2021 - Present",
      points: [
        "[b'Spearheaded] a team of 25 members and elected as a development team lead for the frontend.",
        'Boosted the performance of mobile apps with best practices & DB schema changes & created admin apps to monitor these.',
        'Learned  product development lifecycle and the major aspects we need to consider while developing a product under the guidance of Anshul'
      ],
      image: Assets.images.company.naaniz.path)
];
