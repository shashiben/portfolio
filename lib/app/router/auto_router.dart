import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/modules/About%20Page/about.screen.dart';
import 'package:portfolio/modules/Contact%20Page/contact.screen.dart';
import 'package:portfolio/modules/Dashboard%20Page/dashboard.screen.dart';
import 'package:portfolio/modules/Experience%20Page/experience.screen.dart';
import 'package:portfolio/modules/Home%20Page/screens/home.screen.dart';
import 'package:portfolio/modules/Projects%20Page/projects.screen.dart';
part 'auto_router.gr.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
      page: DashboardScreen,
      initial: true,
      children: [
        AutoRoute(path: 'home', page: HomeScreen),
        AutoRoute(path: 'about', page: AboutScreen),
        AutoRoute(path: 'projects', page: ProjectsScreen),
        AutoRoute(path: 'experience', page: ExperienceScreen),
        AutoRoute(path: 'contact', page: ContactScreen),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter() : super();
}
