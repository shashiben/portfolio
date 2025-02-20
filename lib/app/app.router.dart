import 'package:go_router/go_router.dart';
import 'package:portfolio/ui/views/about%20us%20screen/about_us.screen.dart';
import 'package:portfolio/ui/views/certifications%20screen/certificates.screen.dart';
import 'package:portfolio/ui/views/contact%20us%20screen/contact_us.screen.dart';
import 'package:portfolio/ui/views/dashboard%20screen/dashboard.screen.dart';
import 'package:portfolio/ui/views/home%20screen/home.screen.dart';

final router = GoRouter(
  initialLocation: "/home",
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardScreen(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/home",
            builder: (context, state) {
              return HomeScreen();
            },
          ),
          GoRoute(
            path: "/about-me",
            builder: (context, state) {
              return AboutUsScreen();
            },
          ),
          GoRoute(
            path: "/experience",
            builder: (context, state) {
              return HomeScreen();
            },
          ),
          GoRoute(
            path: "/projects",
            builder: (context, state) {
              return HomeScreen();
            },
          ),
          GoRoute(
            path: "/certificates",
            builder: (context, state) {
              return CertificationScreen();
            },
          ),
          GoRoute(
            path: "/contact-me",
            builder: (context, state) {
              return ContactUsScreen();
            },
          ),
        ])
      ],
    )
  ],
);
