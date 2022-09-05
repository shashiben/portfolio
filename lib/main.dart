import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/app/constants/colors.dart';
import 'package:portfolio/modules/Show%20Case/screens/show_case.screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      theme: ThemeData(
          dividerTheme: const DividerThemeData(
            color: Color(0xFF3F3E45),
          ),
          dividerColor: const Color(0xFF3F3E45),
          primaryColor: ColorConfigs.primaryColor,
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: ColorConfigs.textSecondaryColor),
          scaffoldBackgroundColor: ColorConfigs.backgroundColor,
          backgroundColor: ColorConfigs.backgroundColor,
          fontFamily: GoogleFonts.poppins().fontFamily,
          iconTheme: const IconThemeData(color: Colors.white),
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorConfigs.backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          )),
      debugShowCheckedModeBanner: false,
      home: const ShowCaseScreen(),
    );
  }
}
