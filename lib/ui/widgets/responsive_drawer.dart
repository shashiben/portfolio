import 'package:flutter/material.dart';
import 'package:portfolio/app/app.locator.dart';
import 'package:portfolio/ui/widgets/drawe_text.dart';
import 'package:portfolio/ui/widgets/drawer_hover_effect.dart';
import 'package:stacked_services/stacked_services.dart';

double collapsableHeight = 0.0;
const Color selectedTextColor = Color(0xFFffffff);
const Color unselectedTextColor = Color(0xafffffff);

class ResponsiveDrawer extends StatefulWidget {
  final Widget child;
  final Widget leading;
  final int index;
  final void Function()? onLeadingTap;
  final Function(int index) onPageChanged;
  final Color? selectedTextColor;
  final List<NavBarItem> items;
  final Color? unselectedTextColor;
  final Color? backgroundColor;
  final double mobileMaxWidth;
  const ResponsiveDrawer(
      {Key? key,
      required this.child,
      this.onLeadingTap,
      this.mobileMaxWidth = 800,
      this.leading = const SizedBox(),
      this.backgroundColor,
      required this.index,
      required this.onPageChanged,
      this.items = const [],
      this.selectedTextColor,
      this.unselectedTextColor})
      : super(key: key);
  @override
  _ResponsiveDrawerState createState() => _ResponsiveDrawerState();
}

class _ResponsiveDrawerState extends State<ResponsiveDrawer> {
  final NavigationService navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: width,
            child: widget.child,
            color: Colors.white,
          ),
          AnimatedContainer(
            margin: EdgeInsets.only(top: 80.0),
            duration: Duration(milliseconds: 375),
            curve: Curves.ease,
            height: (width < widget.mobileMaxWidth) ? collapsableHeight : 0.0,
            width: double.infinity,
            color: widget.backgroundColor ?? Color(0xff121212),
            child: SingleChildScrollView(
              child: Column(
                children: widget.items,
              ),
            ),
          ),
          Container(
            color: widget.backgroundColor ?? Color(0xff121212),
            height: 80.0,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: widget.leading,
                  onTap: widget.onLeadingTap ?? () {},
                ),
                LayoutBuilder(builder: (context, constraints) {
                  if (width < widget.mobileMaxWidth) {
                    return NavBarButton(
                      onPressed: () {
                        if (collapsableHeight == 0.0) {
                          setState(() {
                            collapsableHeight = 240.0;
                          });
                        } else if (collapsableHeight == 240.0) {
                          setState(() {
                            collapsableHeight = 0.0;
                          });
                        }
                      },
                    );
                  } else {
                    return Row(
                      children: widget.items,
                    );
                  }
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final String text;
  final Function onTap;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final List<Widget> children;
  NavBarItem(
      {required this.text,
      required this.onTap,
      this.children = const [],
      this.selectedTextColor,
      this.unselectedTextColor});

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem>
    with SingleTickerProviderStateMixin {
  final LabeledGlobalKey buttonKey = LabeledGlobalKey("button");
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.25);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  bool isHovered = false;
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;
  @override
  void initState() {
    super.initState();
    _iconAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _iconAnimation =
        _iconAnimationController.drive(_halfTween.chain(_easeInTween));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (value) {
        setState(() {
          isHovered = false;
        });
      },
      child: Material(
        key: buttonKey,
        color: Colors.transparent,
        child: DrawerHoverEffect(
          mobileMaxWidth: 800,
          onChanged: (value) {
            if (value) {
              _iconAnimationController.forward();
            } else {
              _iconAnimationController.reverse();
            }
          },
          buttonKey: buttonKey,
          children: widget.children,
          child: (widget.children.isEmpty ||
                  MediaQuery.of(context).size.width > 800)
              ? InkWell(
                  splashColor: Colors.white60,
                  onTap: () {
                    widget.onTap();
                  },
                  child: Container(
                    height: 60.0,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 24.0),
                    child: DrawerText(
                      isHovered: isHovered,
                      child: Row(
                        children: [
                          Text(
                            widget.text,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: isHovered
                                  ? selectedTextColor
                                  : unselectedTextColor,
                            ),
                          ),
                          if (widget.children.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: 5.0,
                                ),
                                child: RotationTransition(
                                  turns: _iconAnimation,
                                  child: Icon(
                                    Icons.expand_more,
                                    color: isHovered
                                        ? selectedTextColor
                                        : unselectedTextColor,
                                  ),
                                ))
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 60.0,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isHovered
                              ? selectedTextColor
                              : unselectedTextColor,
                        ),
                      ),
                      if (widget.children.isNotEmpty)
                        Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: RotationTransition(
                              turns: _iconAnimation,
                              child: Icon(
                                Icons.expand_more,
                                color: isHovered
                                    ? selectedTextColor
                                    : unselectedTextColor,
                              ),
                            ))
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class NavBarButton extends StatefulWidget {
  final Function onPressed;

  NavBarButton({required this.onPressed});

  @override
  _NavBarButtonState createState() => _NavBarButtonState();
}

class _NavBarButtonState extends State<NavBarButton> {
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      width: 60.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xcfffffff),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          splashColor: Colors.white60,
          onTap: () {
            widget.onPressed();
          },
          child: Icon(
            Icons.menu,
            size: 30.0,
            color: Color(0xcfffffff),
          ),
        ),
      ),
    );
  }
}
