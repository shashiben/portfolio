import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/widgets/devices/mobile.device.dart';

class AppDevIntroComponent extends StatelessWidget {
  const AppDevIntroComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NextRow(children: [
      NextCol(
        child: Column(
          children: const [
            MobilePhone(),
          ],
        ),
        sizes: 'col-12 col-xxl-6 col-xl-6 col-md-6 col-sm-12',
      ),
      NextCol(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey',
              style: GoogleFonts.markoOne(fontSize: 20),
            )
          ],
        ),
        sizes: 'col-12 col-xxl-6 col-xl-6 col-md-6 col-sm-12',
      )
    ]);
  }
}
