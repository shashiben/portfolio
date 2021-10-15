import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../core/utils/ScreenUiHelper.dart';
import 'translate_on_hover.dart';

class IconWrrapper extends HookWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final Function? onTap;
  final Color? color;
  final EdgeInsets margin;
  final NeumorphicBoxShape? boxShape;

  const IconWrrapper(
      {Key? key,
      this.child,
      this.onTap,
      this.padding,
      this.boxShape,
      this.color,
      this.margin = const EdgeInsets.symmetric(horizontal: 15)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ScreenUiHelper uiHelpers = ScreenUiHelper.fromContext(context);
    final isHovered = useState(false);

    return TranslateOnHover(
      child: MouseRegion(
          onEnter: (event) => isHovered.value = true,
          onExit: (event) => isHovered.value = false,
          child: NeumorphicButton(
            margin: margin,
            onPressed: onTap as void Function()?,
            padding: padding ?? const EdgeInsets.all(12),
            style: NeumorphicStyle(
                border: NeumorphicBorder(
                  color: color ?? uiHelpers.surfaceColor,
                  width: 2,
                ),
                intensity: isHovered.value ? 0.8 : 1,
                boxShape: boxShape ??
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                color: color ?? uiHelpers.backgroundColor,
                lightSource: LightSource.top,
                depth:
                    isHovered.value ? NeumorphicTheme.embossDepth(context) : 4,
                surfaceIntensity: isHovered.value ? 0.25 : 0.5),
            child: child,
          )),
    );
  }
}
