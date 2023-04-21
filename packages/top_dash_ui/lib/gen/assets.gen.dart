/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/background_pattern.png
  AssetGenImage get backgroundPattern =>
      const AssetGenImage('assets/images/background_pattern.png');

  $AssetsImagesCardFramesGen get cardFrames =>
      const $AssetsImagesCardFramesGen();

  /// File path: assets/images/flip_countdown.png
  AssetGenImage get flipCountdown =>
      const AssetGenImage('assets/images/flip_countdown.png');

  /// File path: assets/images/io_flip_logo.svg
  SvgGenImage get ioFlipLogo =>
      const SvgGenImage('assets/images/io_flip_logo.svg');

  /// File path: assets/images/io_flip_logo_03.svg
  SvgGenImage get ioFlipLogo03 =>
      const SvgGenImage('assets/images/io_flip_logo_03.svg');

  $AssetsImagesSuitsGen get suits => const $AssetsImagesSuitsGen();

  /// List of all assets
  List<dynamic> get values =>
      [backgroundPattern, flipCountdown, ioFlipLogo, ioFlipLogo03];
}

class $AssetsImagesCardFramesGen {
  const $AssetsImagesCardFramesGen();

  /// File path: assets/images/card_frames/card_air.png
  AssetGenImage get cardAir =>
      const AssetGenImage('assets/images/card_frames/card_air.png');

  /// File path: assets/images/card_frames/card_back.png
  AssetGenImage get cardBack =>
      const AssetGenImage('assets/images/card_frames/card_back.png');

  /// File path: assets/images/card_frames/card_earth.png
  AssetGenImage get cardEarth =>
      const AssetGenImage('assets/images/card_frames/card_earth.png');

  /// File path: assets/images/card_frames/card_fire.png
  AssetGenImage get cardFire =>
      const AssetGenImage('assets/images/card_frames/card_fire.png');

  /// File path: assets/images/card_frames/card_metal.png
  AssetGenImage get cardMetal =>
      const AssetGenImage('assets/images/card_frames/card_metal.png');

  /// File path: assets/images/card_frames/card_water.png
  AssetGenImage get cardWater =>
      const AssetGenImage('assets/images/card_frames/card_water.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [cardAir, cardBack, cardEarth, cardFire, cardMetal, cardWater];
}

class $AssetsImagesSuitsGen {
  const $AssetsImagesSuitsGen();

  /// File path: assets/images/suits/air.svg
  SvgGenImage get air => const SvgGenImage('assets/images/suits/air.svg');

  /// File path: assets/images/suits/earth.svg
  SvgGenImage get earth => const SvgGenImage('assets/images/suits/earth.svg');

  /// File path: assets/images/suits/fire.svg
  SvgGenImage get fire => const SvgGenImage('assets/images/suits/fire.svg');

  /// File path: assets/images/suits/metal.svg
  SvgGenImage get metal => const SvgGenImage('assets/images/suits/metal.svg');

  /// File path: assets/images/suits/water.svg
  SvgGenImage get water => const SvgGenImage('assets/images/suits/water.svg');

  /// List of all assets
  List<SvgGenImage> get values => [air, earth, fire, metal, water];
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
    String? package = 'top_dash_ui',
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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package = 'top_dash_ui',
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/top_dash_ui/$_assetName';
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package = 'top_dash_ui',
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/top_dash_ui/$_assetName';
}
