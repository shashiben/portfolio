import 'package:flutter/material.dart';
import 'package:portfolio/core/models/timeline_experience.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';
import 'package:portfolio/core/utils/adaptive.dart';

import 'custom shapes/tree_painter.dart';

class ExperienceTree extends StatelessWidget {
  ExperienceTree({
    @required this.experienceData,
    this.head,
    this.widthOfTree,
    this.headTitle,
    this.headTitleStyle,
    this.tailTitleStyle,
    this.tail,
    this.tailTitle,
    this.headBackgroundColor,
    this.tailBackgroundColor,
    this.scrollController,
  });

  final Widget head;
  final double widthOfTree;
  final String headTitle;
  final TextStyle headTitleStyle;
  final TextStyle tailTitleStyle;
  final Color headBackgroundColor;
  final String tailTitle;
  final Color tailBackgroundColor;
  final Widget tail;
  final List<ExperienceTimeline> experienceData;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    return Container(
      child: ListView(
        controller: scrollController,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: headBackgroundColor ??
                    uiHelper.primaryColor.withOpacity(0.1),
              ),
              child: Text(
                headTitle,
                style: headTitleStyle ?? Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          Column(
            children: _buildExperienceBranches(
              context: context,
              experienceData: experienceData,
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: tailBackgroundColor ??
                    uiHelper.primaryColor.withOpacity(0.1),
              ),
              child: Text(
                tailTitle,
                style: tailTitleStyle ??
                    Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: uiHelper.textSecondaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExperienceBranches({
    @required BuildContext context,
    @required List<ExperienceTimeline> experienceData,
  }) {
    List<Widget> branchWidgets = [];
    for (var index = 0; index < experienceData.length; index++) {
      branchWidgets.add(
        ExperienceBranch(
          company: experienceData[index].title,
          position: experienceData[index].position,
          roles: experienceData[index].description,
          location: "",
          duration: experienceData[index].timePeriod,
          width: widthOfTree,
          height: isDisplaySmallDesktop(context)
              ? assignHeight(context: context, fraction: 0.45)
              : assignHeight(context: context, fraction: 0.35),
        ),
      );
    }

    return branchWidgets;
  }
}

class ExperienceBranch extends StatefulWidget {
  ExperienceBranch({
    this.width,
    this.height = 200,
    this.roles,
    this.company,
    this.companyUrl,
    this.position,
    this.location,
    this.duration,
    this.customPainter,
    this.stalk = 0.1,
  });

  final double width;
  final double stalk;
  final double height;
  final String company;
  final String companyUrl;
  final String location;
  final String duration;
  final String position;
  final List<String> roles;
  final CustomPainter customPainter;

  @override
  _ExperienceBranchState createState() => _ExperienceBranchState();
}

class _ExperienceBranchState extends State<ExperienceBranch> {
  GlobalKey roleLeafKey = GlobalKey();
  GlobalKey locationLeafKey = GlobalKey();
  double offsetRoleLeaf;
  double offsetLocationLeaf;

  @override
  void initState() {
    offsetRoleLeaf = (widget.height / 5) - 10;
    offsetLocationLeaf = (widget.height / 2) - 16;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHeightOfRoleLeaf();
    });
    super.initState();
  }

  _getHeightOfRoleLeaf() {
    final RenderBox roleLeafRenderBox =
        roleLeafKey.currentContext.findRenderObject();
    final RenderBox locationLeafRenderBox =
        locationLeafKey.currentContext.findRenderObject();
    final roleLeafHeight = roleLeafRenderBox.size.height;
    final locationLeafHeight = locationLeafRenderBox.size.height;
    setState(() {
      offsetRoleLeaf = (widget.height / 2) - (roleLeafHeight / 2);
      offsetLocationLeaf = (widget.height / 2) - (locationLeafHeight / 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: widget.customPainter ??
          TreePainter(
            stalk: 0.1,
          ),
      child: Container(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            Positioned(
              width: widget.width / 2,
              top: offsetLocationLeaf,
              left: 0,
              child: Container(
                key: locationLeafKey,
                padding: EdgeInsets.only(right: (widget.width * widget.stalk)),
                child: LocationDateLeaf(
                  duration: widget.duration,
                  location: widget.location,
                ),
              ),
            ),
            SizedBox(height: 8),
            Positioned(
              width: widget.width / 2,
              top: offsetRoleLeaf,
              right: 0,
              child: Container(
                key: roleLeafKey,
                padding: EdgeInsets.only(
                  left: (widget.width * widget.stalk),
                ),
                child: RoleLeaf(
                  company: widget.company,
                  onTap: () {},
                  position: widget.position,
                  roles: widget.roles,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LocationDateLeaf extends StatelessWidget {
  LocationDateLeaf({
    @required this.duration,
    @required this.location,
    this.durationIcon,
    this.locationIcon,
    this.locationTextStyle,
    this.durationTextStyle,
  });

  final String duration;
  final TextStyle durationTextStyle;
  final String location;
  final TextStyle locationTextStyle;
  final Icon locationIcon;
  final Icon durationIcon;

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    ThemeData theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                duration,
                style: durationTextStyle ??
                    theme.textTheme.bodyText2.copyWith(color: Colors.black),
              ),
              SizedBox(width: 4),
              Icon(
                    Icons.access_time,
                    color: uiHelper.textSecondaryColor,
                    size: 18,
                  ) ??
                  durationIcon,
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                location,
                style: locationTextStyle ??
                    theme.textTheme.bodyText2.copyWith(color: Colors.black),
              ),
              SizedBox(width: 4),
              Icon(
                    Icons.location_on,
                    color: uiHelper.textSecondaryColor,
                    size: 18,
                  ) ??
                  locationIcon,
            ],
          )
        ],
      ),
    );
  }
}

class RoleLeaf extends StatelessWidget {
  RoleLeaf({
    @required this.company,
    @required this.position,
    @required this.roles,
    this.companyTextStyle,
    this.positionTextStyle,
    this.roleTextStyle,
    this.onTap,
  });

  final String company;
  final String position;
  final List<String> roles;
  final TextStyle companyTextStyle;
  final TextStyle positionTextStyle;
  final TextStyle roleTextStyle;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    ThemeData theme = Theme.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Text(
              company,
              style: companyTextStyle ??
                  theme.textTheme.subtitle1.copyWith(
                      fontSize: 18, color: uiHelper.textSecondaryColor),
            ),
          ),
          Text(
            position,
            style: positionTextStyle ??
                theme.textTheme.subtitle2.copyWith(
                    fontStyle: FontStyle.italic,
                    color: uiHelper.textSecondaryColor),
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildRoles(
              roles: roles,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoles({
    @required List<String> roles,
    @required BuildContext context,
  }) {
    ThemeData theme = Theme.of(context);
    List<Widget> roleWidgets = [];
    for (var index = 0; index < roles.length; index++) {
      roleWidgets.add(
        Role(
          role: roles[index],
          roleTextStyle: roleTextStyle ??
              theme.textTheme.bodyText2.copyWith(color: Colors.black),
        ),
      );
      roleWidgets.add(SizedBox(height: 8));
    }

    return roleWidgets;
  }
}

class Role extends StatelessWidget {
  Role({
    @required this.role,
    this.roleTextStyle,
    this.icon = Icons.arrow_right,
    this.iconSize = 18,
  });

  final String role;
  final TextStyle roleTextStyle;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: uiHelper.primaryColor,
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            role,
            style: roleTextStyle ??
                theme.textTheme.bodyText1.copyWith(
                  color: uiHelper.textPrimaryColor,
                ),
          ),
        ),
      ],
    );
  }
}
