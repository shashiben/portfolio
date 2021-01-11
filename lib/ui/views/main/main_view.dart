import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/app/icons.dart';
import 'package:portfolio/ui/views/about%20me/about_view.dart';
import 'package:portfolio/ui/views/contact%20me/contact_view.dart';
import 'package:portfolio/ui/views/experience/experience_view.dart';
import 'package:portfolio/ui/views/home/home_view.dart';
import 'package:portfolio/ui/views/projects/project_view.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int index = 0;
  List<CollapsibleItem> collapsibleItem = [];
  final views = [
    HomeView(),
    AboutView(),
    ProjectView(),
    ExperienceView(),
    ContactView(),
  ];
  Widget child;

  @override
  void initState() {
    collapsibleItem = _generateItems;
    child = views.first;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  changeIndex(int newIndex) {
    print(newIndex);
    if (newIndex != index) {
      setState(() {
        newIndex = index;
      });
    }
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
          text: 'Home',
          icon: homeIcon,
          onPressed: () => setState(() => child = views[0]),
          isSelected: true),
      CollapsibleItem(
        text: 'About',
        icon: aboutIcon,
        onPressed: () => setState(() => child = views[1]),
      ),
      CollapsibleItem(
        text: 'Projects',
        icon: projectIcon,
        onPressed: () => setState(() => child = views[2]),
      ),
      CollapsibleItem(
        text: 'Experience',
        icon: experienceIcon,
        onPressed: () => setState(() => child = views[3]),
      ),
      CollapsibleItem(
        text: 'Contact',
        icon: contactIcon,
        onPressed: () => setState(() => child = views[4]),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollapsibleSidebar(
          topPadding: 50,
          body: child,
          title: "Shashi Kumar",
          items: collapsibleItem),
    );
  }
}
