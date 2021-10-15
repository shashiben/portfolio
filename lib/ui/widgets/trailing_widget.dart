import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:portfolio/app/configs.dart';
import 'package:portfolio/core/services/url_launcher_service.dart';
import 'package:portfolio/core/utils/ScreenUiHelper.dart';

class TrailingInfo extends StatelessWidget {
  TrailingInfo({
    this.leadingWidget,
    this.middleWidget,
    this.trailingWidget,
    this.spacingWidget,
    this.padding,
    this.info,
    this.width,
    this.onTrailingWidgetPressed,
    this.onLeadingWidgetPressed,
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.end,
  });

  final Widget? leadingWidget;
  final Widget? middleWidget;
  final Widget? trailingWidget;
  final Widget? spacingWidget;
  final EdgeInsetsGeometry? padding;
  final String? info;
  final double? width;
  final Color? color;
  final GestureTapCallback? onTrailingWidgetPressed;
  final GestureTapCallback? onLeadingWidgetPressed;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelper = ScreenUiHelper.fromContext(context);
    ThemeData theme = Theme.of(context);
    return Container(
      width: width,
      padding: padding ??
          EdgeInsets.only(
            top: 30,
            right: 30,
            bottom: 20,
          ),
      color: color,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          NeumorphicFloatingActionButton(
            tooltip: "Mail",
            style: NeumorphicStyle(
                color: uiHelper.primaryColor,
                boxShape: NeumorphicBoxShape.circle()),
            onPressed: () => UrlLauncherService()
                .launchUrl("mailto:${PersonalDetails.email}"),
            child: Center(
              child: leadingWidget ??
                  NeumorphicIcon(
                    Icons.mail,
                    style: NeumorphicStyle(
                      color: Colors.white,
                    ),
                    size: 25,
                  ),
            ),
          ),
          spacingWidget ?? Spacer(flex: 1),
          middleWidget ??
              RotatedBox(
                quarterTurns: 1,
                child: Text(
                  info ?? "${PersonalDetails.email}",
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodyText1!.copyWith(
                    color: uiHelper.textPrimaryColor,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
          spacingWidget ?? Spacer(flex: 1),
          InkWell(
            onTap: onTrailingWidgetPressed,
            child: trailingWidget ??
                CircularContainer(
                  color: uiHelper.primaryColor,
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  CircularContainer({
    this.child,
    this.width = 40,
    this.height = 40,
    this.color,
    this.borderRadius,
  });

  final Color? color;
  final Widget? child;
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(60)),
      child: child,
    );
  }
}
