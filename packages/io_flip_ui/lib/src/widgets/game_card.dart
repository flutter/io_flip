import 'dart:math' as math;
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template game_card_size}
/// A class that holds information about card dimensions.
/// {@endtemplate}
class GameCardSize extends Equatable {
  /// {@macro game_card_size}
  const GameCardSize({
    required this.size,
    required this.badgeSize,
    required this.titleTextStyle,
    required this.descriptionTextStyle,
    required this.powerTextStyle,
    required this.powerTextStrokeWidth,
    required this.imageInset,
  });

  /// XXS size.
  const GameCardSize.xxs()
      : this(
          size: IoFlipCardSizes.xxs,
          titleTextStyle: IoFlipTextStyles.cardTitleXXS,
          descriptionTextStyle: IoFlipTextStyles.cardDescriptionXXS,
          badgeSize: const Size.square(22),
          powerTextStyle: IoFlipTextStyles.cardNumberXXS,
          powerTextStrokeWidth: 2,
          imageInset: const RelativeRect.fromLTRB(4, 3, 4, 24),
        );

  /// XS size.
  const GameCardSize.xs()
      : this(
          size: IoFlipCardSizes.xs,
          badgeSize: const Size.square(41),
          titleTextStyle: IoFlipTextStyles.cardTitleXS,
          descriptionTextStyle: IoFlipTextStyles.cardDescriptionXS,
          powerTextStyle: IoFlipTextStyles.cardNumberXS,
          powerTextStrokeWidth: 2,
          imageInset: const RelativeRect.fromLTRB(8, 6, 8, 44),
        );

  /// SM size.
  const GameCardSize.sm()
      : this(
          size: IoFlipCardSizes.sm,
          badgeSize: const Size.square(55),
          titleTextStyle: IoFlipTextStyles.cardTitleSM,
          descriptionTextStyle: IoFlipTextStyles.cardDescriptionSM,
          powerTextStyle: IoFlipTextStyles.cardNumberSM,
          powerTextStrokeWidth: 2,
          imageInset: const RelativeRect.fromLTRB(12, 10, 12, 60),
        );

  /// MD size.
  const GameCardSize.md()
      : this(
          size: IoFlipCardSizes.md,
          badgeSize: const Size.square(70),
          titleTextStyle: IoFlipTextStyles.cardTitleMD,
          descriptionTextStyle: IoFlipTextStyles.cardDescriptionMD,
          powerTextStyle: IoFlipTextStyles.cardNumberMD,
          powerTextStrokeWidth: 3,
          imageInset: const RelativeRect.fromLTRB(14, 12, 14, 74),
        );

  /// LG size.
  const GameCardSize.lg()
      : this(
          size: IoFlipCardSizes.lg,
          badgeSize: const Size.square(89),
          titleTextStyle: IoFlipTextStyles.cardTitleLG,
          descriptionTextStyle: IoFlipTextStyles.cardDescriptionLG,
          powerTextStyle: IoFlipTextStyles.cardNumberLG,
          powerTextStrokeWidth: 4,
          imageInset: const RelativeRect.fromLTRB(18, 14, 18, 96),
        );

  /// XL size.
  const GameCardSize.xl()
      : this(
          size: IoFlipCardSizes.xl,
          badgeSize: const Size.square(110),
          titleTextStyle: IoFlipTextStyles.cardTitleXL,
          descriptionTextStyle: IoFlipTextStyles.cardDescriptionXL,
          powerTextStyle: IoFlipTextStyles.cardNumberXL,
          powerTextStrokeWidth: 4,
          imageInset: const RelativeRect.fromLTRB(20, 16, 20, 116),
        );

  /// XXL size.
  const GameCardSize.xxl()
      : this(
          size: IoFlipCardSizes.xxl,
          badgeSize: const Size.square(130),
          titleTextStyle: IoFlipTextStyles.cardTitleXXL,
          descriptionTextStyle: IoFlipTextStyles.cardDescriptionXXL,
          powerTextStyle: IoFlipTextStyles.cardNumberXXL,
          powerTextStrokeWidth: 4,
          imageInset: const RelativeRect.fromLTRB(24, 20, 24, 136),
        );

  /// The size of the card.
  final Size size;

  /// The size of the badge.
  final Size badgeSize;

  /// Name text style
  final TextStyle titleTextStyle;

  /// Description text style
  final TextStyle descriptionTextStyle;

  /// Power text style
  final TextStyle powerTextStyle;

  /// Power text stroke width
  final double powerTextStrokeWidth;

  /// The inset of  the image.
  final RelativeRect imageInset;

  /// Get the width of the card.
  double get width => size.width;

  /// Get the height of the card.
  double get height => size.height;

  /// Interpolates between two [GameCardSize]s, linearly by a factor of [t].
  static GameCardSize? lerp(GameCardSize? a, GameCardSize? b, double t) {
    final titleTextStyle = TextStyle.lerp(
      a?.titleTextStyle,
      b?.titleTextStyle,
      t,
    );
    final descriptionTextStyle = TextStyle.lerp(
      a?.descriptionTextStyle,
      b?.descriptionTextStyle,
      t,
    );
    final powerTextStyle = TextStyle.lerp(
      a?.powerTextStyle,
      b?.powerTextStyle,
      t,
    );
    final powerTextStrokeWidth = lerpDouble(
      a?.powerTextStrokeWidth,
      b?.powerTextStrokeWidth,
      t,
    );
    final imageInset = RelativeRect.lerp(
      a?.imageInset,
      b?.imageInset,
      t,
    );
    final size = Size.lerp(a?.size, b?.size, t);
    final badgeSize = Size.lerp(
      a?.badgeSize,
      b?.badgeSize,
      t,
    );

    if (titleTextStyle == null ||
        descriptionTextStyle == null ||
        powerTextStyle == null ||
        powerTextStrokeWidth == null ||
        size == null ||
        badgeSize == null ||
        imageInset == null) {
      return null;
    }

    return GameCardSize(
      imageInset: imageInset,
      size: size,
      badgeSize: badgeSize,
      titleTextStyle: titleTextStyle,
      descriptionTextStyle: descriptionTextStyle,
      powerTextStyle: powerTextStyle,
      powerTextStrokeWidth: powerTextStrokeWidth,
    );
  }

  @override
  List<Object?> get props => [
        size,
        descriptionTextStyle,
        titleTextStyle,
        powerTextStyle,
        powerTextStrokeWidth,
        imageInset,
      ];
}

/// {@template game_card}
/// I/O FLIP Game Card.
/// {@endtemplate}
class GameCard extends StatelessWidget {
  /// {@macro game_card}
  const GameCard({
    required this.image,
    required this.name,
    required this.suitName,
    required this.power,
    required this.description,
    required this.isRare,
    this.size = const GameCardSize.lg(),
    this.overlay,
    this.tilt = Offset.zero,
    @visibleForTesting this.package = 'io_flip_ui',
    super.key,
  });

  /// [CardOverlayType] type of overlay or null if no overlay
  final CardOverlayType? overlay;

  /// The size of the card.
  final GameCardSize size;

  /// Image
  final String image;

  /// Name
  final String name;

  /// Description
  final String description;

  /// Suit name
  final String suitName;

  ///Power
  final int power;

  /// Is a rare card
  final bool isRare;

  /// An offset with x and y values between -1 and 1, representing how much the
  /// card should be tilted.
  final Offset tilt;

  /// The name of the package from which this widget is included.
  ///
  /// This is used to lookup the shader asset.
  @visibleForTesting
  final String? package;

  (String, SvgPicture) _mapSuitNameToAssets() {
    switch (suitName) {
      case 'fire':
        return (
          Assets.images.cardFrames.cardFire.keyName,
          Assets.images.suits.card.fire.svg(),
        );
      case 'water':
        return (
          Assets.images.cardFrames.cardWater.keyName,
          Assets.images.suits.card.water.svg(),
        );
      case 'earth':
        return (
          Assets.images.cardFrames.cardEarth.keyName,
          Assets.images.suits.card.earth.svg(),
        );
      case 'air':
        return (
          Assets.images.cardFrames.cardAir.keyName,
          Assets.images.suits.card.air.svg(),
        );
      case 'metal':
        return (
          Assets.images.cardFrames.cardMetal.keyName,
          Assets.images.suits.card.metal.svg(),
        );
      default:
        throw ArgumentError('Invalid suit name');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (cardFrame, suitSvg) = _mapSuitNameToAssets();
    final shaderChild = Stack(
      children: [
        Positioned.fromRelativeRect(
          rect: size.imageInset,
          child: Image.network(
            image,
            errorBuilder: (_, __, ___) {
              return Container(
                foregroundDecoration: const BoxDecoration(
                  color: IoFlipColors.seedGrey50,
                  backgroundBlendMode: BlendMode.saturation,
                ),
                decoration: const BoxDecoration(
                  color: IoFlipColors.seedBlack,
                ),
                child: IoFlipLogo(),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Image.asset(cardFrame),
        ),
      ],
    );

    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
          child: Transform(
            alignment: Alignment.center,
            transform: CardTransform(
              rotateY: -tilt.dx * math.pi / 8,
              rotateX: tilt.dy * math.pi / 8,
            ),
            child: Stack(
              children: [
                if (isRare)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * 0.08),
                    child: FoilShader(
                      package: package,
                      dx: tilt.dx,
                      dy: tilt.dy,
                      child: shaderChild,
                    ),
                  )
                else
                  shaderChild,
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: size.badgeSize.width,
                    height: size.badgeSize.height,
                    child: Stack(
                      children: [
                        Positioned.fill(child: suitSvg),
                        Align(
                          alignment: const Alignment(.15, .4),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                power.toString(),
                                style: size.powerTextStyle.copyWith(
                                  shadows: [
                                    Shadow(
                                      offset: Offset(
                                        size.size.width * 0.014,
                                        size.size.height * 0.013,
                                      ),
                                      color: IoFlipColors.seedBlack,
                                    ),
                                  ],
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = size.powerTextStrokeWidth
                                    ..color = IoFlipColors.seedBlack,
                                ),
                              ),
                              Text(
                                power.toString(),
                                style: size.powerTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, .5),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: size.titleTextStyle.copyWith(
                      color: IoFlipColors.seedBlack,
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, .95),
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: size.descriptionTextStyle.copyWith(
                          color: IoFlipColors.seedBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (overlay != null)
          CardOverlay.ofType(
            overlay!,
            size.width,
            size.height,
          )
      ],
    );
  }
}
