import 'package:portfolio/ui/views/about%20me/about_view.dart';
import 'package:portfolio/ui/views/contact%20me/contact_view.dart';
import 'package:portfolio/ui/views/experience/experience_view.dart';
import 'package:portfolio/ui/views/home/home_view.dart';
import 'package:portfolio/ui/views/main%20page/main_page.dart';
import 'package:portfolio/ui/views/projects/project_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: MainPage, initial: true, children: [
      MaterialRoute(page: HomeView, path: 'home'),
      MaterialRoute(page: AboutView, path: 'about-shashi'),
      MaterialRoute(page: ExperienceView, path: 'my-experience'),
      MaterialRoute(page: ProjectView, path: 'my-projects'),
      MaterialRoute(page: ContactView, path: 'contact-me'),
    ]),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
  ],
  logger: StackedLogger(),
)
class AppSetup {}
