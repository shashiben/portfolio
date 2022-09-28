import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/app/constants/colors.dart';
import 'package:portfolio/modules/Show%20Case/show_case.screen.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      navigatorKey: StackedService.navigatorKey,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF3F3E45),
        ),
        dividerColor: const Color(0xFF3F3E45),
        primaryColor: ColorConfigs.primaryColor,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: ColorConfigs.textSecondaryColor,
            ),
        scaffoldBackgroundColor: ColorConfigs.backgroundColor,
        backgroundColor: ColorConfigs.backgroundColor,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        iconTheme: const IconThemeData(color: ColorConfigs.iconColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorConfigs.backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(
            color: ColorConfigs.iconColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all(const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300)),
              animationDuration: const Duration(milliseconds: 800),
              shadowColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.focused)) {
                  return const RoundedRectangleBorder();
                }
                return const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                );
              }),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                ColorConfigs.btnColor,
              )),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const ShowCaseScreen(),
    );
  }
}
