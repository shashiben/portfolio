import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/ui/views/main%20page/main_page.dart';

final router = GoRouter(
  urlPathStrategy: UrlPathStrategy.path,
  routes: [
    GoRoute(
      path: '/',
      redirect: (state) => '/home',
      pageBuilder: (context, state) {
        return MaterialPage(child: MainPage(view: 'home'));
      },
    ),
    GoRoute(
      path: '/:view',
      pageBuilder: (context, state) {
        return MaterialPage(
            child: MainPage(view: (state.params['view'] ?? "")));
      },
    )
  ],
  errorPageBuilder: (context, state) => MaterialPage(child: Page404()),
);

class Page404 extends StatelessWidget {
  const Page404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("404"),
      ),
    );
  }
}
