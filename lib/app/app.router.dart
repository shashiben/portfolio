// ignore_for_file: prefer_relative_imports

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'deferred_loader.dart';

import 'package:portfolio/ui/views/contact_us_screen/contact_us_screen.dart' deferred as contact_module;
import 'package:portfolio/ui/views/dashboard_screen/dashboard_screen.dart';
import 'package:portfolio/ui/views/home_screen/home_screen.dart' deferred as home_module;
import 'package:portfolio/ui/views/journey_screen/journey_screen.dart' deferred as journey_module;
import 'package:portfolio/ui/views/work_screen/work_screen.dart' deferred as work_module;

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    ),
  );
}

String? _redirect(BuildContext context, GoRouterState state) {
  switch (state.uri.path) {
    case '/':
      return '/home';
    case '/about-me':
      return '/home';
    case '/experience':
    case '/awards':
    case '/certificates':
      return '/journey';
    case '/projects':
    case '/blogs':
      return '/work';
    default:
      return null;
  }
}

final router = GoRouter(
  initialLocation: '/home',
  redirect: _redirect,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => DashboardScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => _fadePage(
                state,
                DeferredLoader(loadLibrary: home_module.loadLibrary, builder: (_) => home_module.HomeScreen()),
              ),
            ),
            GoRoute(
              path: '/journey',
              pageBuilder: (context, state) => _fadePage(
                state,
                DeferredLoader(loadLibrary: journey_module.loadLibrary, builder: (_) => journey_module.JourneyScreen()),
              ),
            ),
            GoRoute(
              path: '/work',
              pageBuilder: (context, state) => _fadePage(
                state,
                DeferredLoader(loadLibrary: work_module.loadLibrary, builder: (_) => work_module.WorkScreen()),
              ),
            ),
            GoRoute(
              path: '/contact-me',
              pageBuilder: (context, state) => _fadePage(
                state,
                DeferredLoader(
                  loadLibrary: contact_module.loadLibrary,
                  builder: (_) => contact_module.ContactUsScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
