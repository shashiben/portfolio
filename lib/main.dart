import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_strategy/url_strategy.dart';
import 'app/app.locator.dart';
import 'app/router.dart';

Future main() async {
  setPathUrlStrategy();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Shashi Kumar",
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
