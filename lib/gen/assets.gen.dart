// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
//  FlutterGen
// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/django.png
  AssetGenImage get django => const AssetGenImage('assets/icons/django.png');

  /// File path: assets/icons/firebase.png
  AssetGenImage get firebase =>
      const AssetGenImage('assets/icons/firebase.png');

  /// File path: assets/icons/flutter.png
  AssetGenImage get flutter => const AssetGenImage('assets/icons/flutter.png');

  /// File path: assets/icons/git.png
  AssetGenImage get git => const AssetGenImage('assets/icons/git.png');

  /// File path: assets/icons/kotlin.png
  AssetGenImage get kotlin => const AssetGenImage('assets/icons/kotlin.png');

  /// File path: assets/icons/mongo.png
  AssetGenImage get mongo => const AssetGenImage('assets/icons/mongo.png');

  /// File path: assets/icons/python.png
  AssetGenImage get python => const AssetGenImage('assets/icons/python.png');

  /// File path: assets/icons/react.png
  AssetGenImage get react => const AssetGenImage('assets/icons/react.png');
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/avatar.png
  AssetGenImage get avatar => const AssetGenImage('assets/images/avatar.png');

  $AssetsImagesCompanyGen get company => const $AssetsImagesCompanyGen();

  $AssetsImagesSkillGen get skill => const $AssetsImagesSkillGen();
}

class $AssetsImagesCompanyGen {
  const $AssetsImagesCompanyGen();

  /// File path: assets/images/company/naaniz.png
  AssetGenImage get naaniz =>
      const AssetGenImage('assets/images/company/naaniz.png');

  /// File path: assets/images/company/webknot.png
  AssetGenImage get webknot =>
      const AssetGenImage('assets/images/company/webknot.png');
}

class $AssetsImagesSkillGen {
  const $AssetsImagesSkillGen();

  /// File path: assets/images/skill/android.png
  AssetGenImage get android =>
      const AssetGenImage('assets/images/skill/android.png');

  /// File path: assets/images/skill/backend.png
  AssetGenImage get backend =>
      const AssetGenImage('assets/images/skill/backend.png');

  /// File path: assets/images/skill/luffy.png
  AssetGenImage get luffy =>
      const AssetGenImage('assets/images/skill/luffy.png');

  /// File path: assets/images/skill/ml.png
  AssetGenImage get ml => const AssetGenImage('assets/images/skill/ml.png');

  /// File path: assets/images/skill/web.png
  AssetGenImage get web => const AssetGenImage('assets/images/skill/web.png');
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(super.assetName);

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
  }) =>
      Image(
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

  String get path => assetName;
}
