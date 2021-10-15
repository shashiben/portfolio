import 'dart:math' as math;

import 'package:flutter/material.dart';

List<String> _prefixes = ['xl', 'lg', 'md', 'sm', ''];
List<String> _prefixesReversed = ['', 'sm', 'md', 'lg', 'xl'];

double _oneColumnRatio = 0.083333;
double _gutterSize = 48.0;
int _numberOfColumns = 12;

///
/// Customization of the grid
///
void bootstrapGridParameters({
  int numberOfColumns = 12,
  double gutterSize = 24,
}) {
  assert(() {
    if (numberOfColumns < 10 || numberOfColumns > 24) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('Invalid number of columns: $numberOfColumns'),
        ErrorHint('The number of columns must be inside the [10; 24] range.'),
      ]);
    }

    if (gutterSize < 0.0 || gutterSize > 96.0) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('Invalid gutter size: $gutterSize'),
        ErrorHint('The gutterSize must be inside the [0.0; 96.0] range.'),
      ]);
    }

    return true;
  }());

  //
  // Memorize the parameters
  //
  _numberOfColumns = numberOfColumns;
  _oneColumnRatio = 1.0 / numberOfColumns;
  _gutterSize = gutterSize;
}

///
/// Returns the definition prefix, based on the available width
///
String bootstrapPrefixBasedOnWidth(double width) {
  const String pfx = '';

  if (width > 1200) {
    return 'xl';
  }

  if (width > 992) {
    return 'lg';
  }

  if (width > 768) {
    return 'md';
  }

  if (width > 575) {
    return 'sm';
  }

  return pfx;
}

///
/// Returns the max width for non-fluid containers
/// based on a certain provided width
///
double bootstrapMaxWidthNonFluid(double width) {
  ///
  /// Otherwise, it depends on the available width
  ///
  if (width >= 1200) {
    return 1140;
  }
  if (width >= 992) {
    return 960;
  }
  if (width >= 768) {
    return 720;
  }
  if (width >= 576) {
    return 540;
  }
  return width;
}

///
/// Implementation of the Bootstrap .container and .container-fluid
///
class BootstrapContainer extends StatelessWidget {
  const BootstrapContainer({
    Key? key,
    required this.children,
    this.fluid = false,
    this.decoration,
    this.padding,
  }) : super(key: key);

  ///
  /// Is the container fluid => if yes, takes the whole width
  /// Default value: false
  ///
  final bool fluid;

  ///
  /// Any potential BoxDecoration
  ///
  final BoxDecoration? decoration;

  ///
  /// Children
  ///
  final List<Widget> children;

  ///
  /// Padding
  ///
  final EdgeInsets? padding;

  //
  // Computes the max-width of a container, based on the available space
  //
  double _getMaxWidth(double width) {
    //
    // If the container is fluid, no constraints in terms of width
    //
    if (fluid) {
      return width;
    }

    //
    // Otherwise, it depends on the available width
    //
    return bootstrapMaxWidthNonFluid(width);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //
        // Get the max width of the container
        //
        final double width = _getMaxWidth(constraints.maxWidth);

        Widget widget = Container(
          width: width,
          decoration: decoration,
          child: Wrap(
            children: children,
          ),
        );

        if (padding != null) {
          widget = Padding(
            padding: padding!,
            child: widget,
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: widget,
        );
      },
    );
  }
}

///
/// Implementation of the Bootstap .row
///
/// A [BootstapRow] may only contain [BootstapCol] children.
///
class BootstrapRow extends StatelessWidget {
  const BootstrapRow({
    Key? key,
    this.height,
    this.decoration,
    required this.children,
  }) : super(key: key);

  ///
  /// Min container height
  ///
  final double? height;

  ///
  /// Any potential BoxDecoration
  ///
  final BoxDecoration? decoration;

  ///
  /// List of the children of type [BootstrapCol]
  ///
  final List<BootstrapCol> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //
        // Get the prefix for the definition, based on the available width
        //
        final String pfx = bootstrapPrefixBasedOnWidth(constraints.maxWidth);

        //
        // We need to iterate through all the children and consider any potential order
        //
        final List<BootstrapCol> _children = List.from(children);
        _children.sort((a, b) => a.orderPerSize[pfx]! - b.orderPerSize[pfx]!);

        return Container(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            maxWidth: constraints.maxWidth,
            minHeight: height!,
          ),
          decoration: decoration,
          child: Wrap(
            children: _children,
          ),
        );
      },
    );
  }
}

///
/// Implementation of the Bootstap .col-*
///
class BootstrapCol extends StatelessWidget {
  BootstrapCol({
    Key? key,
    required this.child,
    this.fit = FlexFit.loose,
    this.absoluteSizes = true,
    String sizes = '',
    String offsets = '',
    String orders = '',
    this.invisibleForSizes,
  })  : sizes = sizes.trim(),
        offsets = offsets.trim(),
        orders = orders.trim(),
        super(key: key) {
    _initialize();
  }

  ///
  /// The child
  ///
  final Widget child;

  /// How a flexible child is inscribed into the available space.
  ///
  /// If [flex] is non-zero, the [fit] determines whether the child fills the
  /// space the parent makes available during layout. If the fit is
  /// [FlexFit.tight], the child is required to fill the available space. If the
  /// fit is [FlexFit.loose], the child can be at most as large as the available
  /// space (but is allowed to be smaller).
  final FlexFit fit;

  ///
  /// Sizes
  ///
  /// Corresponds to the Bootstrap classes: .col-*
  ///
  /// Defines the dimensions (in terms of number of columns),
  /// depending on the screen width.
  ///
  /// Example:
  ///   sizes: 'col-12 col-sd-12 col-md-6 col-lg-4 col-xl-4'
  ///
  final String sizes;

  ///
  /// Offsets (= number of columns) to push this Widget to the right
  ///
  /// Corresponds to the Bootstrap classes: .offset-*
  ///
  /// Example:
  ///   offsets: 'offset-0 offset-sm-1 offset-md-2 offset-lg-3 offset-xl-4'
  ///
  final String offsets;

  ///
  /// Sequence orders
  ///
  /// Corresponds to the Bootstrap classes: .order-*
  ///
  /// Example:
  ///   orders: 'order-2 order-sm-2 order-md-1 order-lg-1 order-xl-1'
  ///
  final String orders;

  ///
  /// Invisibility
  ///
  /// If you want to make this instance invisible for extra-small devices, mention the 'xs'
  ///
  /// Example:
  ///   invisibleForSizes: 'xs xl'
  ///
  final String? invisibleForSizes;

  ///
  /// Do we consider relative dimensions (based on the parent container)
  /// or absolute (based on the browser window)
  /// Default: relative = false
  ///
  final bool absoluteSizes;

  //
  // Flex ratios per size, based on the column's definition
  //
  final Map<String, int?> _ratiosPerSize = {
    'xl': 100,
    'lg': 100,
    'md': 100,
    'sm': 100,
    '': 100,
  };

  //
  // Offsets per size, based on the column's definition
  //
  final Map<String, int?> _offsetsPerSize = {
    'xl': -100,
    'lg': -100,
    'md': -100,
    'sm': -100,
    '': -100,
  };

  //
  // Sequence order per size, based on the column's definition
  //
  final Map<String, int?> orderPerSize = {
    'xl': 0,
    'lg': 0,
    'md': 0,
    'sm': 0,
    '': 0,
  };

  //
  // Sequence order per size, based on the column's definition
  //
  final Map<String, bool> hiddenPerSize = {
    'xl': false,
    'lg': false,
    'md': false,
    'sm': false,
    '': false,
  };

  //
  // Defines the Flex ratios, based on the column's
  // definition, as well as the offsets
  //
  void _initialize() {
    final int nbPrefixes = _prefixes.length;

    void _initArray({
      required String referenceArgument,
      Map<String, int?>? map,
      String? argPrefix,
      Function? minMaxFct,
      int lowerBoundValue = 0,
      int? noValue,
      int? minMaxNoValueReference,
    }) {
      //
      // Identification of the defined "dimensions"
      //
      final List<String> parts = referenceArgument.isEmpty
          ? []
          : referenceArgument
              .toLowerCase()
              .split(' ')
              .where((t) => t.trim().isNotEmpty)
              .toList();
      for (final String part in parts) {
        for (final String pfx in _prefixes) {
          final String prefix = '$argPrefix-$pfx${pfx == "" ? "" : "-"}';
          if (part.startsWith(prefix)) {
            final String? valString = part.split(prefix).last;
            if (valString != prefix && valString != null) {
              final int? value = int.tryParse(valString);
              if (value != null && value < 13 && value > lowerBoundValue) {
                map![pfx] = minMaxFct!(map[pfx], value);
              }
            }
          }
        }
      }

      //
      // As there might be holes, we need to re-adapt
      //
      for (int idx = 0; idx < nbPrefixes; idx++) {
        final String pfx = _prefixesReversed[idx];
        int? value = map![pfx];

        if (value == noValue) {
          //
          // No definition was found for this prefix
          //
          int i;

          //
          // Look for the nearest value in higher resolutions
          //
          for (i = idx + 1; i < nbPrefixes; i++) {
            final String pfx2 = _prefixesReversed[i];
            if (map[pfx2] != noValue) {
              value = map[pfx2];
              break;
            }
          }

          if (value == noValue) {
            //
            // Look for the nearest value in lower resolutions
            //
            for (int j = i - 1; j > -1; j--) {
              final String pfx3 = _prefixesReversed[j];
              if (map[pfx3] != noValue) {
                value = map[pfx3];
                break;
              }
            }
          }

          map[pfx] = minMaxFct!(minMaxNoValueReference, value);
        }
      }
    }

    //
    // First, the sizes (flex => col-*)
    //
    _initArray(
      referenceArgument: sizes,
      map: _ratiosPerSize,
      argPrefix: 'col',
      minMaxFct: math.min,
      noValue: 100,
      minMaxNoValueReference: _numberOfColumns,
    );

    //
    // Then, the offsets (=> offset-*  => marginLeft)
    //
    _initArray(
      referenceArgument: offsets,
      map: _offsetsPerSize,
      argPrefix: 'offset',
      minMaxFct: math.max,
      noValue: -100,
      minMaxNoValueReference: 0,
      lowerBoundValue: -1,
    );

    //
    // ... the sequence orders (=> order-*)
    //
    _initArray(
      referenceArgument: orders,
      map: orderPerSize,
      argPrefix: 'order',
      minMaxFct: math.max,
      noValue: -100,
      minMaxNoValueReference: 0,
    );

    //
    // Finally, invisibility
    //
    final List<String> parts = (invisibleForSizes ?? '').trim().isEmpty
        ? []
        : invisibleForSizes!
            .toLowerCase()
            .split(' ')
            .where((t) => t.trim().isNotEmpty)
            .toList();
    for (final pfx in parts) {
      if (['xl', 'lg', 'md', 'sm', 'xs'].contains(pfx)) {
        hiddenPerSize[pfx == 'xs' ? '' : pfx] = true;
      }
    }
  }

  //
  // Returns the flex ratio % column's definition and available width of
  // the container
  //
  int? _getFlexRatio(String prefix) {
    return _ratiosPerSize[prefix];
  }

  //
  // Returns the leftMargin % column's definition and available width of
  // the container.  This corresponds to the offset-*
  //
  int _getLeftMarginRatio(String prefix) {
    return _offsetsPerSize[prefix] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //
        // Get the prefix for the definition, based on the available width
        //
        final String pfx = bootstrapPrefixBasedOnWidth(absoluteSizes
            ? MediaQuery.of(context).size.width
            : constraints.maxWidth);

        //
        // Check if invisible
        //
        final bool isInvisible = hiddenPerSize[pfx]!;

        if (isInvisible) {
          return Container();
        }

        //
        //
        // Get the flexible ratio
        //
        final int flexRatio = _getFlexRatio(pfx)!;

        //
        // Get the margin-left (offset)
        //
        final int leftMarginRatio = _getLeftMarginRatio(pfx);

        Widget widget = SizedBox(
          width: flexRatio * constraints.maxWidth * _oneColumnRatio,
          child: Padding(
            padding: _gutterSize == 0.0
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: _gutterSize / 2),
            child: child,
          ),
        );

        if (leftMarginRatio > 0) {
          final double leftMargin =
              constraints.maxWidth * leftMarginRatio * _oneColumnRatio;
          widget = Padding(
            padding: EdgeInsets.only(left: leftMargin),
            child: widget,
          );
        }

        return widget;
      },
    );
  }
}

///
/// Helper Widget which defines whether its child is visible
/// depending on the parent container width and the rules
/// defined in [sizes]
///
class BootstrapVisibility extends StatelessWidget {
  BootstrapVisibility({
    Key? key,
    required this.child,
    String sizes = '',
  })  : sizes = sizes.trim(),
        super(key: key) {
    _initialize();
  }

  ///
  /// The child to display (or not)
  ///
  final Widget child;

  ///
  /// Sizes
  ///
  /// corresponds to .col*
  /// If the 'col-*' that corresponds to the screen dimensions is present,
  /// the child is displayed.  Otherwise, the child is not displayed.
  ///
  final String sizes;

  //
  // Visibility per size, based on the column's definition
  //
  final Map<String, bool> _visibilityPerSize = {
    'xl': false,
    'lg': false,
    'md': false,
    'sm': false,
    '': false,
  };

  //
  // Defines the Flex ratios, based on the column's
  // definition, as well as the offsets
  //
  void _initialize() {
    //
    // Parsing of the rules
    //
    final List<String> parts = sizes.isEmpty
        ? []
        : sizes
            .toLowerCase()
            .split(' ')
            .where((t) => t.trim().isNotEmpty)
            .toList();
    for (final part in parts) {
      for (final pfx in _prefixes) {
        final String prefix = 'col-$pfx';
        if (part.startsWith(prefix) && pfx != '') {
          _visibilityPerSize[pfx] = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    // Get the prefix for the definition, based on the available width
    //
    String pfx = bootstrapPrefixBasedOnWidth(MediaQuery.of(context).size.width);
    if (pfx == '') {
      pfx = 'xs';
    }

    //
    // Check if it is visible
    //
    final bool? visible = _visibilityPerSize[pfx];

    if (visible == false) {
      return Container();
    }

    return child;
  }
}

///
/// Returns "something" based on the current dimensions
/// everything is related to browser window
///
/// Example:
/// something = bootStrapValueBasedOnSize(
///   {
///    "xl": "value for xl",
///    "lg": "value for lg",
///    "md": "value for md",
///    "sm": "value for sm",
///    "": "value for xs",
///   },
///   context: context,
/// )
///
/// If the sizes does not contain the corresponding browser prefix,
/// returns the nearest (upper first)
///
dynamic bootStrapValueBasedOnSize({
  required Map<String, dynamic> sizes,
  required BuildContext context,
}) {
  //
  // Get the prefix for the definition, based on the available width
  //
  final String pfx =
      bootstrapPrefixBasedOnWidth(MediaQuery.of(context).size.width);

  final int nbPrefixes = _prefixes.length;
  dynamic value;

  //
  // As there might be holes, we need to re-adapt
  //
  value = sizes[pfx];

  if (value == null) {
    //
    // No definition was found for this prefix
    //
    int i;
    final int idx = _prefixes.indexOf(pfx);

    //
    // Look for the nearest value in higher resolutions
    //
    for (i = idx + 1; i < nbPrefixes; i++) {
      final String pfx2 = _prefixesReversed[i];
      if (sizes[pfx2] != null) {
        value = sizes[pfx2];
        break;
      }
    }

    if (value == null) {
      //
      // Look for the nearest value in lower resolutions
      //
      for (int j = i - 1; j > -1; j--) {
        final String pfx3 = _prefixesReversed[j];
        if (sizes[pfx3] != null) {
          value = sizes[pfx3];
          break;
        }
      }
    }
  }

  return value;
}
