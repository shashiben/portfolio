// ignore_for_file: prefer_relative_imports

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:portfolio/app/theme/app_motion.dart';
import 'package:portfolio/ui/views/contact/contact_us_screen.dart' deferred as contact_module;
import 'package:portfolio/ui/views/dashboard/dashboard_screen.dart';
import 'package:portfolio/ui/views/home/home_screen.dart' deferred as home_module;
import 'package:portfolio/ui/views/journey/journey_screen.dart' deferred as journey_module;
import 'package:portfolio/ui/views/work/work_screen.dart' deferred as work_module;

import 'deferred_loader.dart';

String? _shellPath;
int _shellDir = 1;

int _navRank(String path) {
  if (path.startsWith('/journey')) return 1;
  if (path.startsWith('/work')) return 2;
  if (path.startsWith('/contact')) return 3;
  return 0;
}

int _shellDirection(String path) {
  final next = _navRank(path);
  if (_shellPath == path) return _shellDir;
  final prev = _shellPath == null ? next : _navRank(_shellPath!);
  _shellDir = next >= prev ? 1 : -1;
  _shellPath = path;
  return _shellDir;
}

CustomTransitionPage<void> _shellPage(GoRouterState state, Widget child) {
  final dir = _shellDirection(state.uri.path);
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 450),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (AppMotion.reduceMotion(context)) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      }
      final slide = Tween<Offset>(
        begin: Offset(0.045 * dir, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: AppMotion.easeOut));
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(position: slide, child: child),
      );
    },
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
              pageBuilder: (context, state) => _shellPage(
                state,
                DeferredLoader(loadLibrary: home_module.loadLibrary, builder: (_) => home_module.HomeScreen()),
              ),
            ),
            GoRoute(
              path: '/journey',
              pageBuilder: (context, state) => _shellPage(
                state,
                DeferredLoader(loadLibrary: journey_module.loadLibrary, builder: (_) => journey_module.JourneyScreen()),
              ),
            ),
            GoRoute(
              path: '/work',
              pageBuilder: (context, state) => _shellPage(
                state,
                DeferredLoader(loadLibrary: work_module.loadLibrary, builder: (_) => work_module.WorkScreen()),
              ),
            ),
            GoRoute(
              path: '/contact-me',
              pageBuilder: (context, state) => _shellPage(
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
