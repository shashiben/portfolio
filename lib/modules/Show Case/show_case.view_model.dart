import 'package:portfolio/modules/About%20Page/about.screen.dart';
import 'package:portfolio/modules/Home%20Page/screens/home.screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stacked/stacked.dart';
import 'package:portfolio/modules/Contact%20Page/contact.screen.dart';
import 'package:portfolio/modules/Experience%20Page/experience.screen.dart';
import 'package:portfolio/modules/Feature%20Section/feature.section.dart';
import 'package:portfolio/modules/Projects%20Page/projects.screen.dart';
import '../../widgets/components/footer.dart';

class ShowCaseViewModel extends BaseViewModel {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final views = [
    const HomeScreen(),
    const AboutScreen(),
    const FeatureSection(),
    const ExperienceScreen(),
    const ProjectsScreen(),
    const ContactScreen(),
    const FooterWidget()
  ];
}
