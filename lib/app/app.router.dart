// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/about%20me/about_view.dart';
import '../ui/views/contact%20me/contact_view.dart';
import '../ui/views/experience/experience_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/main%20page/main_page.dart';
import '../ui/views/projects/project_view.dart';

class Routes {
  static const String mainPage = '/';
  static const all = <String>{
    mainPage,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(
      Routes.mainPage,
      page: MainPage,
      generator: MainPageRouter(),
    ),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    MainPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => MainPage(
          view: '',
        ),
        settings: data,
      );
    },
  };
}

class MainPageRoutes {
  static const String homeView = 'home';
  static const String aboutView = 'about-shashi';
  static const String experienceView = 'my-experience';
  static const String projectView = 'my-projects';
  static const String contactView = 'contact-me';
  static const all = <String>{
    homeView,
    aboutView,
    experienceView,
    projectView,
    contactView,
  };
}

class MainPageRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(MainPageRoutes.homeView, page: HomeView),
    RouteDef(MainPageRoutes.aboutView, page: AboutView),
    RouteDef(MainPageRoutes.experienceView, page: ExperienceView),
    RouteDef(MainPageRoutes.projectView, page: ProjectView),
    RouteDef(MainPageRoutes.contactView, page: ContactView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    AboutView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AboutView(),
        settings: data,
      );
    },
    ExperienceView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ExperienceView(),
        settings: data,
      );
    },
    ProjectView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ProjectView(),
        settings: data,
      );
    },
    ContactView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ContactView(),
        settings: data,
      );
    },
  };
}
