import 'package:flutter/material.dart';

enum _GridTier { xs, sm, md, lg, xl }

class ResponsiveGridRow extends StatefulWidget {
  final List<ResponsiveGridCol> children;
  final CrossAxisAlignment crossAxisAlignment;

  ResponsiveGridRow(
      {@required this.children,
      this.crossAxisAlignment = CrossAxisAlignment.start});

  @override
  _ResponsiveGridRowState createState() => _ResponsiveGridRowState();
}

class _ResponsiveGridRowState extends State<ResponsiveGridRow> {
  double _refWidth = 375;

  double _scalingFactor;
  double _width;

  void initScaling(BuildContext context) {
    var mq = MediaQuery.of(context);
    _width = mq.size.width < mq.size.height ? mq.size.width : mq.size.height;
    _scalingFactor = _width / _refWidth;

    print("width => $_width");
  }

  double scale(double dimension) {
    if (_width == null) {
      throw Exception("You must call init() before any use of scale()");
    }

    return dimension * _scalingFactor;
  }

  int _totalSegments = 12;
  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    int accumulatedWidth = 0;
    List<Widget> cols = [];

    widget.children.forEach((col) {
      var colWidth = col.currentConfig(context);

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
    });

    if (accumulatedWidth >= 0) {
      if (accumulatedWidth < _totalSegments) {
        cols.add(Spacer(
          flex: _totalSegments - accumulatedWidth,
        ));
      }
      rows.add(Row(
        crossAxisAlignment: this.widget.crossAxisAlignment,
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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.width;
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
      {int xs = 12, int sm, int md, int lg, int xl, @required this.child}) {
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
  final double desiredItemWidth, minSpacing;
  final List<Widget> children;
  final bool squareCells, scroll;
  final MainAxisAlignment rowMainAxisAlignment;

  ResponsiveGridList(
      {this.desiredItemWidth,
      this.minSpacing,
      this.squareCells = false,
      this.scroll = true,
      this.children,
      this.rowMainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (children.length == 0) return Container();
        double width = constraints.maxWidth;
        double N = (width - minSpacing) / (desiredItemWidth + minSpacing);
        int n;
        double spacing, itemWidth;
        if (N % 1 == 0) {
          n = N.floor();
          spacing = minSpacing;
          itemWidth = desiredItemWidth;
        } else {
          n = N.floor();
          double dw =
              width - (n * (desiredItemWidth + minSpacing) + minSpacing);
          itemWidth = desiredItemWidth +
              (dw / n) * (desiredItemWidth / (desiredItemWidth + minSpacing));
          spacing = (width - itemWidth * n) / (n + 1);
        }
        if (scroll) {
          return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: (children.length / n).ceil() * 2 - 1,
              itemBuilder: (context, index) {
                if (index % 2 == 1) {
                  return SizedBox(
                    height: minSpacing,
                  );
                }
                var rowChildren = [];
                index = index ~/ 2;
                for (int i = index * n; i < (index + 1) * n; i++) {
                  if (i >= children.length) break;
                  rowChildren.add(children[i]);
                }
                return _ResponsiveGridListItem(
                  mainAxisAlignment: this.rowMainAxisAlignment,
                  itemWidth: itemWidth,
                  spacing: spacing,
                  squareCells: squareCells,
                  children: rowChildren,
                );
              });
        } else {
          var rows = [];
          rows.add(SizedBox(
            height: minSpacing,
          ));

          for (int j = 0; j < (children.length / n).ceil(); j++) {
            var rowChildren = [];

            for (int i = j * n; i < (j + 1) * n; i++) {
              if (i >= children.length) break;
              rowChildren.add(children[i]);
            }

            rows.add(_ResponsiveGridListItem(
              mainAxisAlignment: this.rowMainAxisAlignment,
              itemWidth: itemWidth,
              spacing: spacing,
              squareCells: squareCells,
              children: rowChildren,
            ));

            rows.add(SizedBox(
              height: minSpacing,
            ));
          }

          return Column(
            children: rows,
          );
        }
      },
    );
  }
}

class _ResponsiveGridListItem extends StatelessWidget {
  final double spacing, itemWidth;
  final List<Widget> children;
  final bool squareCells;
  final MainAxisAlignment mainAxisAlignment;

  _ResponsiveGridListItem(
      {this.itemWidth,
      this.spacing,
      this.squareCells,
      this.children,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: this.mainAxisAlignment,
      children: _buildChildren(),
    );
  }

  List<Widget> _buildChildren() {
    var list = [];

    list.add(SizedBox(
      width: spacing,
    ));

    children.forEach((child) {
      list.add(SizedBox(
        width: itemWidth,
        height: squareCells ? itemWidth : null,
        child: child,
      ));
      list.add(SizedBox(
        width: spacing,
      ));
    });

    return list;
  }
}
