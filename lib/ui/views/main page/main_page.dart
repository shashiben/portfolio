import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/app/router.dart';
import 'package:portfolio/ui/views/about%20me/about_view.dart';
import 'package:portfolio/ui/views/contact%20me/contact_view.dart';
import 'package:portfolio/ui/views/experience/experience_view.dart';
import 'package:portfolio/ui/views/home/home_view.dart';
import 'package:portfolio/ui/views/projects/project_view.dart';
import 'package:portfolio/ui/widgets/drawe_text.dart';

import 'package:portfolio/ui/widgets/responsive_drawer.dart';

class MainPage extends HookWidget {
  final String view;

  final Map<String, Widget> views = {
    "home": HomeView(),
    "about-shashi": AboutView(),
    "contact": ContactView(),
    "my-projects": ProjectView(),
    "my-experience": ExperienceView()
  };
  final navKey = new GlobalKey<NavigatorState>();

  MainPage({Key? key, required this.view}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveDrawer(
        backgroundColor: Color(0xFF1f1b3d),
        index: 0,
        leading: Image.asset(
          'assets/images/sk_logo.png',
          height: 40,
        ),
        onLeadingTap: () {
          context.push('/home');
        },
        onPageChanged: (int newIndex) {},
        items: [
          NavBarItem(
            text: 'About',
            onTap: () {
              context.push('/about-shashi');
            },
          ),
          NavBarItem(
            text: 'Projects',
            onTap: () {
              context.push('/my-projects');
            },
            children: [
              ListTile(
                title: HoverWidget(
                  child: Text(
                    'All',
                    style: TextStyle(color: Colors.white),
                  ),
                  width: 10,
                ),
                onTap: () {},
              ),
              ListTile(
                title: HoverWidget(
                  child: Text(
                    'Apps',
                    style: TextStyle(color: Colors.white),
                  ),
                  width: 20,
                ),
                onTap: () {},
              ),
              ListTile(
                title: HoverWidget(
                  child: Text(
                    'Website',
                    style: TextStyle(color: Colors.white),
                  ),
                  width: 20,
                ),
                onTap: () {},
              ),
              ListTile(
                title: HoverWidget(
                  child: Text(
                    'Others',
                    style: TextStyle(color: Colors.white),
                  ),
                  width: 20,
                ),
                onTap: () {},
              )
            ],
          ),
          NavBarItem(
            text: 'Experience',
            onTap: () {
              context.push('/my-experience');
            },
          ),
          NavBarItem(
            text: 'Contact',
            onTap: () {
              context.push('/contact');
            },
          ),
        ],
        child: views[view] ?? Page404());
  }
}
