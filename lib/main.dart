import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'app/app.locator.dart';
import 'app/router.dart';

Future main() async {
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
