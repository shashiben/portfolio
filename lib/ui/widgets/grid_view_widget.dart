import 'package:flutter/material.dart';

enum _GridTier { xs, sm, md, lg, xl }

class ResponsiveGridRow extends StatefulWidget {
  final List<ResponsiveGridCol>? children;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsiveGridRow(
      {Key? key,
      required this.children,
      this.crossAxisAlignment = CrossAxisAlignment.start})
      : super(key: key);

  @override
  _ResponsiveGridRowState createState() => _ResponsiveGridRowState();
}

class _ResponsiveGridRowState extends State<ResponsiveGridRow> {
  final double _refWidth = 375;

  late double _scalingFactor;
  double? _width;

  void initScaling(BuildContext context) {
    final mq = MediaQuery.of(context);
    _width = mq.size.width < mq.size.height ? mq.size.width : mq.size.height;
    _scalingFactor = _width! / _refWidth;
  }

  double scale(double dimension) {
    if (_width == null) {
      throw Exception('You must call init() before any use of scale()');
    }

    return dimension * _scalingFactor;
  }

  final int _totalSegments = 12;
  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    int accumulatedWidth = 0;
    List<Widget> cols = [];

    for (final col in widget.children!) {
      final colWidth = col.currentConfig(context);

      if (accumulatedWidth + colWidth > _totalSegments) {
        if (accumulatedWidth < _totalSegments) {
          cols.add(Spacer(
            flex: _totalSegments - accumulatedWidth,
          ));
        }
        rows.add(Row(
          children: cols,
        ));
        cols = [];
        accumulatedWidth = 0;
      }

      cols.add(col);
      accumulatedWidth += colWidth;
    }

    if (accumulatedWidth >= 0) {
      if (accumulatedWidth < _totalSegments) {
        cols.add(Spacer(
          flex: _totalSegments - accumulatedWidth,
        ));
      }
      rows.add(Row(
        crossAxisAlignment: widget.crossAxisAlignment,
        children: cols,
      ));
    }

    return Column(
      children: rows,
    );
  }
}

class ResponsiveGridCol extends StatelessWidget {
  _GridTier getCurrentSize(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    if (width < 576) {
      return _GridTier.xs;
    } else if (width < 768) {
      return _GridTier.sm;
    } else if (width < 992) {
      return _GridTier.md;
    } else if (width < 1200) {
      return _GridTier.lg;
    } else {
      return _GridTier.xl;
    }
  }

  final List<int> _config = [0, 1, 2, 3, 4];
  final Widget child;

  ResponsiveGridCol(
      {Key? key,
      int xs = 12,
      int? sm,
      int? md,
      int? lg,
      int? xl,
      required this.child})
      : super(key: key) {
    _config[_GridTier.xs.index] = xs;
    _config[_GridTier.sm.index] = sm ?? _config[_GridTier.xs.index];
    _config[_GridTier.md.index] = md ?? _config[_GridTier.sm.index];
    _config[_GridTier.lg.index] = lg ?? _config[_GridTier.md.index];
    _config[_GridTier.xl.index] = xl ?? _config[_GridTier.lg.index];
  }

  int currentConfig(BuildContext context) {
    return _config[getCurrentSize(context).index];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: currentConfig(context),
      child: child,
    );
  }
}

class ResponsiveGridList extends StatelessWidget {
  final double? desiredItemWidth, minSpacing;
  final List<Widget>? children;
  final bool? squareCells, scroll;
  final MainAxisAlignment rowMainAxisAlignment;

  const ResponsiveGridList(
      {Key? key,
      this.minSpacing,
      this.children,
      this.scroll = true,
      this.rowMainAxisAlignment = MainAxisAlignment.start,
      this.desiredItemWidth,
      this.squareCells})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (children!.isEmpty) return Container();
        final double width = constraints.maxWidth;
        final double N = (width - minSpacing!) / (desiredItemWidth! + minSpacing!);
        int n;
        double? spacing, itemWidth;
        if (N % 1 == 0) {
          n = N.floor();
          spacing = minSpacing;
          itemWidth = desiredItemWidth;
        } else {
          n = N.floor();
          final double dw =
              width - (n * (desiredItemWidth! + minSpacing!) + minSpacing!);
          itemWidth = desiredItemWidth! +
              (dw / n) *
                  (desiredItemWidth! / (desiredItemWidth! + minSpacing!));
          spacing = (width - itemWidth * n) / (n + 1);
        }
        if (scroll ?? false) {
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: (children!.length / n).ceil() * 2 - 1,
              itemBuilder: (context, index) {
                if (index % 2 == 1) {
                  return SizedBox(
                    height: minSpacing,
                  );
                }
                final rowChildren = [];
                index = index ~/ 2;
                for (int i = index * n; i < (index + 1) * n; i++) {
                  if (i >= children!.length) break;
                  rowChildren.add(children![i]);
                }
                return _ResponsiveGridListItem(
                  mainAxisAlignment: rowMainAxisAlignment,
                  itemWidth: itemWidth,
                  spacing: spacing,
                  squareCells: squareCells,
                  children: rowChildren as List<Widget>?,
                );
              });
        } else {
          final rows = [];
          rows.add(SizedBox(
            height: minSpacing,
          ));

          for (int j = 0; j < (children!.length / n).ceil(); j++) {
            final rowChildren = [];

            for (int i = j * n; i < (j + 1) * n; i++) {
              if (i >= children!.length) break;
              rowChildren.add(children![i]);
            }

            rows.add(_ResponsiveGridListItem(
              mainAxisAlignment: rowMainAxisAlignment,
              itemWidth: itemWidth,
              spacing: spacing,
              squareCells: squareCells,
              children: rowChildren as List<Widget>?,
            ));

            rows.add(SizedBox(
              height: minSpacing,
            ));
          }

          return Column(
            children: rows as List<Widget>,
          );
        }
      },
    );
  }
}

class _ResponsiveGridListItem extends StatelessWidget {
  final double? spacing, itemWidth;
  final List<Widget>? children;
  final bool? squareCells;
  final MainAxisAlignment mainAxisAlignment;

  const _ResponsiveGridListItem(
      {this.itemWidth,
      this.spacing,
      this.squareCells,
      this.children,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    final list = [];

    list.add(SizedBox(
      width: spacing,
    ));

    for (final child in children!) {
      list.add(SizedBox(
        width: itemWidth,
        height: squareCells! ? itemWidth : null,
        child: child,
      ));
      list.add(SizedBox(
        width: spacing,
      ));
    }

    return list as List<Widget>;
  }
}
