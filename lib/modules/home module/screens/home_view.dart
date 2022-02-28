import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            NextRow(
              children: [
                NextCol(
                  sizes:
                      "col-12 col-xl-6 col-lg-6 col-md-6 col-xs-12 col-sm-12",
                  child: Container(),
                ),
                NextCol(
                  sizes:
                      "col-12 col-xl-6 col-lg-6 col-md-6 col-xs-12 col-sm-12",
                  child: Container(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
