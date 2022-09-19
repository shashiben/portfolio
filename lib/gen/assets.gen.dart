/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/android.png
  AssetGenImage get androidPng =>
      const AssetGenImage('assets/icons/android.png');

  /// File path: assets/icons/android.svg
  String get androidSvg => 'assets/icons/android.svg';

  /// File path: assets/icons/backend.svg
  String get backend => 'assets/icons/backend.svg';

  /// File path: assets/icons/bootstrap.png
  AssetGenImage get bootstrap =>
      const AssetGenImage('assets/icons/bootstrap.png');

  /// File path: assets/icons/css.png
  AssetGenImage get css => const AssetGenImage('assets/icons/css.png');

  /// File path: assets/icons/django.png
  AssetGenImage get django => const AssetGenImage('assets/icons/django.png');

  /// File path: assets/icons/firebase.png
  AssetGenImage get firebase =>
      const AssetGenImage('assets/icons/firebase.png');

  /// File path: assets/icons/flask.png
  AssetGenImage get flask => const AssetGenImage('assets/icons/flask.png');

  /// File path: assets/icons/flutter.png
  AssetGenImage get flutter => const AssetGenImage('assets/icons/flutter.png');

  /// File path: assets/icons/git.png
  AssetGenImage get git => const AssetGenImage('assets/icons/git.png');

  /// File path: assets/icons/heroku.png
  AssetGenImage get heroku => const AssetGenImage('assets/icons/heroku.png');

  /// File path: assets/icons/html.png
  AssetGenImage get html => const AssetGenImage('assets/icons/html.png');

  /// File path: assets/icons/java.png
  AssetGenImage get java => const AssetGenImage('assets/icons/java.png');

  /// File path: assets/icons/js.png
  AssetGenImage get js => const AssetGenImage('assets/icons/js.png');

  /// File path: assets/icons/kotlin.png
  AssetGenImage get kotlin => const AssetGenImage('assets/icons/kotlin.png');

  /// File path: assets/icons/menu.svg
  String get menu => 'assets/icons/menu.svg';

  /// File path: assets/icons/mongo.png
  AssetGenImage get mongo => const AssetGenImage('assets/icons/mongo.png');

  /// File path: assets/icons/opencv.png
  AssetGenImage get opencv => const AssetGenImage('assets/icons/opencv.png');

  /// File path: assets/icons/others.svg
  String get others => 'assets/icons/others.svg';

  /// File path: assets/icons/pandas.png
  AssetGenImage get pandas => const AssetGenImage('assets/icons/pandas.png');

  /// File path: assets/icons/postman.png
  AssetGenImage get postman => const AssetGenImage('assets/icons/postman.png');

  /// File path: assets/icons/python.png
  AssetGenImage get python => const AssetGenImage('assets/icons/python.png');

  /// File path: assets/icons/react.png
  AssetGenImage get react => const AssetGenImage('assets/icons/react.png');

  /// File path: assets/icons/web.svg
  String get web => 'assets/icons/web.svg';
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/android.png
  AssetGenImage get android => const AssetGenImage('assets/images/android.png');

  /// File path: assets/images/avatar.png
  AssetGenImage get avatar => const AssetGenImage('assets/images/avatar.png');

  /// File path: assets/images/background.jpg
  AssetGenImage get background =>
      const AssetGenImage('assets/images/background.jpg');

  /// File path: assets/images/business.png
  AssetGenImage get business =>
      const AssetGenImage('assets/images/business.png');

  /// File path: assets/images/design.png
  AssetGenImage get design => const AssetGenImage('assets/images/design.png');

  /// File path: assets/images/ml.png
  AssetGenImage get ml => const AssetGenImage('assets/images/ml.png');

  /// File path: assets/images/pattern.png
  AssetGenImage get pattern => const AssetGenImage('assets/images/pattern.png');

  /// File path: assets/images/s.png
  AssetGenImage get s => const AssetGenImage('assets/images/s.png');

  /// File path: assets/images/sk_logo.png
  AssetGenImage get skLogo => const AssetGenImage('assets/images/sk_logo.png');

  /// File path: assets/images/web.png
  AssetGenImage get web => const AssetGenImage('assets/images/web.png');
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
