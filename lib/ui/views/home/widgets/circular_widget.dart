import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as Math;

const double _radiansPerDegree = Math.pi / 180;
final double _startAngle = -90.0 * _radiansPerDegree;
typedef double ItemAngleCalculator(int index);

class CircularWidgets extends StatelessWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;

  final int itemsLength;

  final double radiusOfItem;

  final double centerWidgetRadius;

  final WidgetBuilder? centerWidgetBuilder;

  final double innerSpacing;
  const CircularWidgets({
    Key? key,
    required this.itemBuilder,
    required this.itemsLength,
    this.radiusOfItem = 100,
    this.centerWidgetBuilder,
    this.centerWidgetRadius = 150,
    this.innerSpacing = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, LayoutId> itemIds = {};
    for (var i = 0; i < itemsLength; i++) {
      final id = 'Item($i)';
      itemIds[id] = LayoutId(
        id: 'Item($i)',
        child: SizedBox(
          height: radiusOfItem,
          width: radiusOfItem,
          child: itemBuilder(context, i),
        ),
      );
    }
    final circleWidget = centerWidgetBuilder == null
        ? null
        : LayoutId(
            id: 'CenterItem',
            child: SizedBox(
              height: centerWidgetRadius,
              width: centerWidgetRadius,
              child: centerWidgetBuilder?.call(context),
            ),
          );

    return CustomMultiChildLayout(
      delegate: CircularLayoutDelegate(
        idItems: itemIds,
        centerCircleLayoutId: circleWidget,
        radius: (centerWidgetRadius + innerSpacing + radiusOfItem) / 2,
      ),
      children: [
        ...itemIds.values.toList(),
        if (circleWidget != null) circleWidget
      ],
    );
  }
}

class CircularLayoutDelegate extends MultiChildLayoutDelegate {
  final Map<String, LayoutId> idItems;
  final LayoutId? centerCircleLayoutId;
  final double radius;

  CircularLayoutDelegate({
    required this.idItems,
    required this.radius,
    this.centerCircleLayoutId,
  });

  @override
  void performLayout(Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    double _itemSpacing = 360.0 / idItems.length;

    var itemValues = idItems.values.toList();
    for (int i = 0; i < idItems.length; i++) {
      final idItem = itemValues[i];

      final Object id = idItem.id;

      final Size buttonSize = layoutChild(id, BoxConstraints.loose(size));
      int actualIndex = i;

      final double itemAngle =
          _startAngle + actualIndex * _itemSpacing * _radiansPerDegree;

      positionChild(
        id,
        new Offset(
          (center.dx - buttonSize.width / 2) + (radius) * Math.cos(itemAngle),
          (center.dy - buttonSize.height / 2) + (radius) * Math.sin(itemAngle),
        ),
      );
    }

    final centerLayoutId = centerCircleLayoutId;
    if (centerLayoutId != null) {
      final Size buttonSize =
          layoutChild(centerLayoutId.id, BoxConstraints.loose(size));
      positionChild(
        centerLayoutId.id,
        Offset(
          center.dx - (buttonSize.width / 2),
          center.dy - (buttonSize.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRelayout(CircularLayoutDelegate oldDelegate) =>
      !mapEquals(idItems, oldDelegate.idItems) ||
      radius != oldDelegate.radius ||
      centerCircleLayoutId?.child != oldDelegate.centerCircleLayoutId?.child ||
      radius != oldDelegate.radius;
}
