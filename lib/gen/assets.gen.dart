/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/cancel.svg
  String get cancel => 'assets/icons/cancel.svg';

  /// List of all assets
  List<String> get values => [cancel];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/add.png
  AssetGenImage get add => const AssetGenImage('assets/images/add.png');

  /// File path: assets/images/facebook.png
  AssetGenImage get facebook =>
      const AssetGenImage('assets/images/facebook.png');

  /// File path: assets/images/main.png
  AssetGenImage get main => const AssetGenImage('assets/images/main.png');

  /// File path: assets/images/twitter.png
  AssetGenImage get twitter => const AssetGenImage('assets/images/twitter.png');

  /// List of all assets
  List<AssetGenImage> get values => [add, facebook, main, twitter];
}

class $AssetsMusicGen {
  const $AssetsMusicGen();

  /// File path: assets/music/Mr_Smith-Azul.mp3
  String get mrSmithAzul => 'assets/music/Mr_Smith-Azul.mp3';

  /// File path: assets/music/Mr_Smith-Sonorus.mp3
  String get mrSmithSonorus => 'assets/music/Mr_Smith-Sonorus.mp3';

  /// File path: assets/music/Mr_Smith-Sunday_Solitude.mp3
  String get mrSmithSundaySolitude =>
      'assets/music/Mr_Smith-Sunday_Solitude.mp3';

  /// File path: assets/music/README.md
  String get readme => 'assets/music/README.md';

  /// List of all assets
  List<String> get values =>
      [mrSmithAzul, mrSmithSonorus, mrSmithSundaySolitude, readme];
}

class $AssetsSfxGen {
  const $AssetsSfxGen();

  /// File path: assets/sfx/add_to_hand.mp3
  String get addToHand => 'assets/sfx/add_to_hand.mp3';

  /// File path: assets/sfx/card_movement.mp3
  String get cardMovement => 'assets/sfx/card_movement.mp3';

  /// File path: assets/sfx/click.mp3
  String get click => 'assets/sfx/click.mp3';

  /// File path: assets/sfx/clock_running.mp3
  String get clockRunning => 'assets/sfx/clock_running.mp3';

  /// File path: assets/sfx/damage.mp3
  String get damage => 'assets/sfx/damage.mp3';

  /// File path: assets/sfx/deck_open.mp3
  String get deckOpen => 'assets/sfx/deck_open.mp3';

  /// File path: assets/sfx/draw_match.mp3
  String get drawMatch => 'assets/sfx/draw_match.mp3';

  /// File path: assets/sfx/fire.mp3
  String get fire => 'assets/sfx/fire.mp3';

  /// File path: assets/sfx/ground.mp3
  String get ground => 'assets/sfx/ground.mp3';

  /// File path: assets/sfx/holo_reveal.mp3
  String get holoReveal => 'assets/sfx/holo_reveal.mp3';

  /// File path: assets/sfx/lost_match.mp3
  String get lostMatch => 'assets/sfx/lost_match.mp3';

  /// File path: assets/sfx/metal.mp3
  String get metal => 'assets/sfx/metal.mp3';

  /// File path: assets/sfx/play_card.mp3
  String get playCard => 'assets/sfx/play_card.mp3';

  /// File path: assets/sfx/reveal.mp3
  String get reveal => 'assets/sfx/reveal.mp3';

  /// File path: assets/sfx/round_lost.mp3
  String get roundLost => 'assets/sfx/round_lost.mp3';

  /// File path: assets/sfx/round_win.mp3
  String get roundWin => 'assets/sfx/round_win.mp3';

  /// File path: assets/sfx/start_game.mp3
  String get startGame => 'assets/sfx/start_game.mp3';

  /// File path: assets/sfx/water.mp3
  String get water => 'assets/sfx/water.mp3';

  /// File path: assets/sfx/win_match.mp3
  String get winMatch => 'assets/sfx/win_match.mp3';

  /// File path: assets/sfx/wind.mp3
  String get wind => 'assets/sfx/wind.mp3';

  /// List of all assets
  List<String> get values => [
        addToHand,
        cardMovement,
        click,
        clockRunning,
        damage,
        deckOpen,
        drawMatch,
        fire,
        ground,
        holoReveal,
        lostMatch,
        metal,
        playCard,
        reveal,
        roundLost,
        roundWin,
        startGame,
        water,
        winMatch,
        wind
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsMusicGen music = $AssetsMusicGen();
  static const $AssetsSfxGen sfx = $AssetsSfxGen();
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

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
