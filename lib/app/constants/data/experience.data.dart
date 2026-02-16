import '../../../core/models/company.model.dart';
import '../../../gen/assets.gen.dart';

List<Company> experienceList = [
  Company(
    name: 'TopRecur',
    period: 'Jan 2021 - Feb 2021',
    points: [
      'Worked as an intern for mobile app development and front end developer.',
      'Application is similar to Workflowy for note taking.',
      'Added export service of all the data present in the parent node.',
      'Added functionality to customize text styling dynamically.',
    ],
  ),
  Company(
    name: 'Naaniz',
    period: 'May 2020 - July 2020',
    points: [
      'Managing a team of 25 members, able to divide and assign works to them.',
      'Designed DB Schema and made the UI of the app responsive.',
      'Integrated Payment Gateway Integration (Razorpay).',
      'Implemented Video Broadcasting feature, Chat bot, Voice Search.',
    ],
    image: Assets.images.company.naaniz.path,
  ),
  Company(
    name: 'Webknot Technologies Pvt Ltd.',
    period: 'May 2021 - Present',
    image: Assets.images.company.webknot.path,
    subEntries: [
      ExperienceSubEntry(
        period: 'Nov 2024 - Nov 2025',
        title: 'Senior Team Lead',
        points: [
          'Worked with client Jio to build IDE plugin for Intellij based which creates dynamically Android SDK.'
        ],
      ),
      ExperienceSubEntry(
        period: 'Aug 2022 - Oct 2024',
        title: 'Senior Software Developer',
        awardIds: [
          'spot_award_jan_2023',
          'spot_award_sep_2023',
          'spot_award_betsol_apr_2024',
          'spot_award_sep_2024',
        ],
        points: [
          'Worked with Betsol/Avaya to build Messaging Android SDK',
        ],
      ),
      ExperienceSubEntry(
        period: 'Aug 2021 - Jul 2022',
        title: 'SDE - 1',
        awardIds: [
          'spot_award_oct_2021',
          'mvp_oct_2022',
        ],
        points: [
          'Built and shipped 3+ production Flutter apps.',
          'Integrated payment gateways and KIOSK device configurations.',
        ],
      ),
      ExperienceSubEntry(
        period: 'Apr 2021 - Jul 2021',
        title: 'Full Stack Developer Intern',
        awardIds: ['mvp_may_2021'],
        points: [
          'Worked on Hubble project to create LMS application with private file sharing, video player etc...',
        ],
      ),
    ],
  ),
  Company(
      name: 'Sharpsell Technologies',
      period: 'Nov 2025 - Present',
      isCurrent: true,
      points: [],
      subEntries: [
        ExperienceSubEntry(
            period: 'Nov 2025 - Present',
            title: 'Senior Flutter Developer',
            points: [
              'Building flutter web app which is multi-platform, so need to support web, android, iOS',
              'Worked on migrating flutter version from 3.16.* to 3.38.*',
            ])
      ])
];
