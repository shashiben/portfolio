import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/models/company.model.dart';

import 'custom_text.widget.dart';

class CompanyItem extends StatelessWidget {
  final Company company;
  final bool isReverse;
  const CompanyItem({
    Key? key,
    required this.company,
    required this.isReverse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: NextRow(children: getChildren(context)),
    );
  }

  List<NextCol> getChildren(BuildContext context) {
    List<NextCol> children = [
      NextCol(
          sizes: 'col-12 col-md-6',
          child: Container(
            height: 300,
            decoration: const BoxDecoration(color: Color(0xffFBFAFA)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(company.image),
            ),
          )),
      NextCol(
        sizes: 'col-12 col-md-6',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company.name,
              style: GoogleFonts.breeSerif(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(company.period,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(
              height: 12,
            ),
            ...company.points
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Icon(
                              FontAwesomeIcons.arrowRightLong,
                              size: 12,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: CustomText(
                              text: e,
                              textMap: {
                                'b': GoogleFonts.breeSerif(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                )
                              },
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList()
          ],
        ),
      )
    ];

    return (isReverse && context.width >= 992)
        ? children.reversed.toList()
        : children;
  }
}
