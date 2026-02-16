// ignore_for_file: prefer_relative_imports

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'deferred_loader.dart';

import 'package:portfolio/ui/views/about_us_screen/about_us_screen.dart'
    deferred as about_module;
import 'package:portfolio/ui/views/blogs_screen/blogs_screen.dart'
    deferred as blogs_module;
import 'package:portfolio/ui/views/certificates_screen/certificates_screen.dart'
    deferred as certificates_module;
import 'package:portfolio/ui/views/awards_screen/awards_screen.dart'
    deferred as awards_module;
import 'package:portfolio/ui/views/contact_us_screen/contact_us_screen.dart'
    deferred as contact_module;
import 'package:portfolio/ui/views/dashboard_screen/dashboard_screen.dart';
import 'package:portfolio/ui/views/experience_screen/experience_screen.dart'
    deferred as experience_module;
import 'package:portfolio/ui/views/home_screen/home_screen.dart'
    deferred as home_module;
import 'package:portfolio/ui/views/projects_screen/projects_screen.dart'
    deferred as projects_module;

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    ),
  );
}

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => DashboardScreen(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => _fadePage(
              state,
              DeferredLoader(
                loadLibrary: home_module.loadLibrary,
                builder: (_) => home_module.HomeScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/about-me',
            pageBuilder: (context, state) => _fadePage(
              state,
              DeferredLoader(
                loadLibrary: about_module.loadLibrary,
                builder: (_) => about_module.AboutUsScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/experience',
            pageBuilder: (context, state) => _fadePage(
              state,
              DeferredLoader(
                loadLibrary: experience_module.loadLibrary,
                builder: (_) => experience_module.ExperienceScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) => _fadePage(
              state,
              DeferredLoader(
                loadLibrary: projects_module.loadLibrary,
                builder: (_) => projects_module.ProjectsScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/certificates',
            pageBuilder: (context, state) => _fadePage(
              state,
              DeferredLoader(
                loadLibrary: certificates_module.loadLibrary,
                builder: (_) => certificates_module.CertificatesScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/awards',
            pageBuilder: (context, state) => _fadePage(
              state,
              DeferredLoader(
                loadLibrary: awards_module.loadLibrary,
                builder: (_) => awards_module.AwardsScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/blogs',
            pageBuilder: (context, state) => _fadePage(
              state,
              DeferredLoader(
                loadLibrary: blogs_module.loadLibrary,
                builder: (_) => blogs_module.BlogsScreen(),
              ),
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
        ]),
      ],
    ),
  ],
);
