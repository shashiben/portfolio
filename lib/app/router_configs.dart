import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/common%20widgets/invalid_page.dart';
import 'package:portfolio/modules/main%20module/screens/main_screen.dart';

final router = GoRouter(
  urlPathStrategy: UrlPathStrategy.path,
  errorPageBuilder: (context, state) => MaterialPage(
    child: const InvalidPage(),
    key: state.pageKey,
    restorationId: state.pageKey.value,
  ),
  routes: [
    GoRoute(path: '/', redirect: (state) => "/portfolio/home"),
    GoRoute(
      path: '/portfolio/:routeId',
      pageBuilder: (context, state) {
        final routeId = state.params['routeId']!;

        return MaterialPage(
          child: MainScreen(
            key: state.pageKey,
            title: routeId,
          ),
        );
      },
    ),
  ],
);
