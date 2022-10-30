// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'auto_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    DashboardScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const DashboardScreen());
    },
    HomeScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const HomeScreen());
    },
    AboutScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const AboutScreen());
    },
    ProjectsScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ProjectsScreen());
    },
    ExperienceScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ExperienceScreen());
    },
    ContactScreenRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
          routeData: routeData, child: const ContactScreen());
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(DashboardScreenRoute.name, path: '/', children: [
          RouteConfig(HomeScreenRoute.name,
              path: 'home', parent: DashboardScreenRoute.name),
          RouteConfig(AboutScreenRoute.name,
              path: 'about', parent: DashboardScreenRoute.name),
          RouteConfig(ProjectsScreenRoute.name,
              path: 'projects', parent: DashboardScreenRoute.name),
          RouteConfig(ExperienceScreenRoute.name,
              path: 'experience', parent: DashboardScreenRoute.name),
          RouteConfig(ContactScreenRoute.name,
              path: 'contact', parent: DashboardScreenRoute.name)
        ])
      ];
}

/// generated route for
/// [DashboardScreen]
class DashboardScreenRoute extends PageRouteInfo<void> {
  const DashboardScreenRoute({List<PageRouteInfo>? children})
      : super(DashboardScreenRoute.name, path: '/', initialChildren: children);

  static const String name = 'DashboardScreenRoute';
}

/// generated route for
/// [HomeScreen]
class HomeScreenRoute extends PageRouteInfo<void> {
  const HomeScreenRoute() : super(HomeScreenRoute.name, path: 'home');

  static const String name = 'HomeScreenRoute';
}

/// generated route for
/// [AboutScreen]
class AboutScreenRoute extends PageRouteInfo<void> {
  const AboutScreenRoute() : super(AboutScreenRoute.name, path: 'about');

  static const String name = 'AboutScreenRoute';
}

/// generated route for
/// [ProjectsScreen]
class ProjectsScreenRoute extends PageRouteInfo<void> {
  const ProjectsScreenRoute()
      : super(ProjectsScreenRoute.name, path: 'projects');

  static const String name = 'ProjectsScreenRoute';
}

/// generated route for
/// [ExperienceScreen]
class ExperienceScreenRoute extends PageRouteInfo<void> {
  const ExperienceScreenRoute()
      : super(ExperienceScreenRoute.name, path: 'experience');

  static const String name = 'ExperienceScreenRoute';
}

/// generated route for
/// [ContactScreen]
class ContactScreenRoute extends PageRouteInfo<void> {
  const ContactScreenRoute() : super(ContactScreenRoute.name, path: 'contact');

  static const String name = 'ContactScreenRoute';
}
