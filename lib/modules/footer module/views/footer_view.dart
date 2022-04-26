import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_next/flutter_next.dart';

import '../../../app/data/social_links.dart';
import '../widgets/footer_item.dart';

class FooterView extends StatelessWidget {
  const FooterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: context.isMobile ? 20 : context.width * 0.05,
              vertical: 40),
          color: Colors.white,
          width: context.width,
          child: NextRow(verticalSpacing: 30, children: [
            NextCol(
                sizes: 'col-12 cik-md-6 col-lg-3',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shashi Kumar B',
                      style: TextStyle(fontSize: 26, color: Color(0xFF444444)),
                    ).container(padding: const EdgeInsets.only(bottom: 10)),
                    const Text(
                      'Chittari street,Kurnool\nAndhra Pradesh, Ap 518001\nIndia.',
                      style: TextStyle(
                          height: 1.5, fontSize: 14, color: Color(0xFF777777)),
                    ).container(padding: const EdgeInsets.only(bottom: 15)),
                    const Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Phone:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF444444))),
                      TextSpan(
                          text: '+91-7997217156',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF777777)))
                    ])).container(padding: const EdgeInsets.only(bottom: 8)),
                    const Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Email:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF444444))),
                      TextSpan(
                          text: 'kumarshashi5294@gmail.com',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF777777)))
                    ]))
                  ],
                )),
            NextCol(
                sizes: 'col-12 col-md-6 col-lg-3',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Useful Links',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ).container(padding: const EdgeInsets.only(bottom: 12)),
                    const FooterItem(title: 'Home'),
                    const FooterItem(title: 'About us'),
                    const FooterItem(title: 'Services'),
                    const FooterItem(title: 'Terms of service'),
                    const FooterItem(title: 'Privacy policy'),
                  ],
                )),
            NextCol(
                sizes: 'col-12 col-md-6 col-lg-3',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Services',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ).container(padding: const EdgeInsets.only(bottom: 12)),
                    const FooterItem(title: 'Web Design'),
                    const FooterItem(title: 'Web Development'),
                    const FooterItem(title: 'Product Management'),
                    const FooterItem(title: 'Marketing'),
                    const FooterItem(title: 'Graphic Design'),
                  ],
                )),
            NextCol(
                sizes: 'col-12 col-md-6 col-lg-3',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Social Links',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ).container(padding: const EdgeInsets.only(bottom: 12)),
                    ...List.generate(
                            socialLinks.length,
                            (index) => FooterItem(
                                title: socialLinks.elementAt(index).title))
                        .toList(),
                  ],
                ))
          ]),
        ),
        Container(
          color: const Color(0xFFF8FBFE),
          padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: context.isMobile ? 20 : context.width * 0.05),
          width: context.width,
          child: Container(
            color: const Color(0xFFF8FBFE),
            width: context.width,
            child: NextRow(verticalSpacing: 15, children: [
              NextCol(
                  sizes: 'col-12 col-md-6',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(TextSpan(style: const TextStyle(), children: [
                        const TextSpan(text: '© Created by '),
                        TextSpan(
                            text: 'Shashi. ',
                            recognizer: TapGestureRecognizer()..onTap = () {},
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: 'With Flutter.'),
                      ])).container(padding: const EdgeInsets.only(bottom: 10)),
                      Text.rich(TextSpan(style: const TextStyle(), children: [
                        const TextSpan(text: 'With the help of '),
                        TextSpan(
                            text: 'Flutter Next ',
                            recognizer: TapGestureRecognizer()..onTap = () {},
                            style: TextStyle(
                                color: context.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ])),
                    ],
                  )),
              NextCol(
                  sizes: 'col-12 col-lg-6 col-md-6',
                  child: Row(
                      mainAxisAlignment: context.isMobile
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.end,
                      children: List.generate(
                        socialLinks.length,
                        (index) => NextButton(
                            margin: const EdgeInsets.only(right: 10),
                            itemBuilder: (context, bool isHovered, color) =>
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: context.primaryColor),
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    socialLinks[index].icon,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                            onPressed: () {}),
                      )))
            ]),
          ),
        ),
      ],
    );
  }
}
