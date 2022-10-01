/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bat_background.jpg
  AssetGenImage get batBackground =>
      const AssetGenImage('assets/images/bat_background.jpg');

  /// File path: assets/images/bat_promo.jpg
  AssetGenImage get batPromo =>
      const AssetGenImage('assets/images/bat_promo.jpg');

  /// File path: assets/images/batman.jpg
  AssetGenImage get batman => const AssetGenImage('assets/images/batman.jpg');

  /// File path: assets/images/ca_shield.jpg
  AssetGenImage get caShield =>
      const AssetGenImage('assets/images/ca_shield.jpg');

  /// File path: assets/images/dano.jpg
  AssetGenImage get dano => const AssetGenImage('assets/images/dano.jpg');

  /// File path: assets/images/dron.jpg
  AssetGenImage get dron => const AssetGenImage('assets/images/dron.jpg');

  /// File path: assets/images/immortals.jpg
  AssetGenImage get immortals =>
      const AssetGenImage('assets/images/immortals.jpg');

  /// File path: assets/images/kravitz.jpg
  AssetGenImage get kravitz => const AssetGenImage('assets/images/kravitz.jpg');

  /// File path: assets/images/pattisson.jpg
  AssetGenImage get pattisson =>
      const AssetGenImage('assets/images/pattisson.jpg');

  /// File path: assets/images/plane.jpg
  AssetGenImage get plane => const AssetGenImage('assets/images/plane.jpg');

  /// File path: assets/images/spider.jpg
  AssetGenImage get spider => const AssetGenImage('assets/images/spider.jpg');

  /// File path: assets/images/wright.jpg
  AssetGenImage get wright => const AssetGenImage('assets/images/wright.jpg');
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
