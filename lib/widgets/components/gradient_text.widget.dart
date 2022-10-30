import 'package:flutter/material.dart';

enum GradientType {
  linear,
  radial,
}

enum GradientDirection {
  bottomToTop,
  leftToRight,
  rightToLeft,
  topToBottom,
}

class GradientText extends StatelessWidget {
  final List<Color> colors;
  final GradientDirection? gradientDirection;
  final GradientType gradientType;
  final TextOverflow? overflow;
  final double radius;
  final TextStyle? style;
  final String text;
  final TextAlign? textAlign;
  final double? textScaleFactor;
  final int? maxLines;

  const GradientText(
    this.text, {
    required this.colors,
    this.gradientDirection = GradientDirection.leftToRight,
    this.gradientType = GradientType.linear,
    Key? key,
    this.overflow,
    this.radius = 1.0,
    this.style,
    this.textAlign,
    this.textScaleFactor,
    this.maxLines,
  })  : assert(
          colors.length >= 2,
          'Colors list must have at least two colors',
        ),
        super(key: key);

  @override
  Widget build(final BuildContext context) {
    return ShaderMask(
      shaderCallback: (final Rect bounds) {
        switch (gradientType) {
          case GradientType.linear:
            final Map<String, Alignment> map = {};
            switch (gradientDirection) {
              case GradientDirection.rightToLeft:
                map['begin'] = Alignment.centerRight;
                map['end'] = Alignment.centerLeft;
                break;
              case GradientDirection.topToBottom:
                map['begin'] = Alignment.topCenter;
                map['end'] = Alignment.bottomCenter;
                break;
              case GradientDirection.bottomToTop:
                map['begin'] = Alignment.bottomCenter;
                map['end'] = Alignment.topCenter;
                break;
              default:
                map['begin'] = Alignment.centerLeft;
                map['end'] = Alignment.centerRight;
                break;
            }
            return LinearGradient(
              begin: map['begin']!,
              colors: colors,
              end: map['end']!,
            ).createShader(bounds);
          case GradientType.radial:
            return RadialGradient(
              colors: colors,
              radius: radius,
            ).createShader(bounds);
        }
      },
      child: Text(
        text,
        overflow: overflow,
        style: style != null
            ? style?.copyWith(color: Colors.white)
            : const TextStyle(color: Colors.white),
        textScaleFactor: textScaleFactor,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }
}
