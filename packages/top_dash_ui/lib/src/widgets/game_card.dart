import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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
          size: TopDashCardSizes.xxs,
          titleTextStyle: TopDashTextStyles.cardTitleXXS,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionXXS,
          badgeSize: const Size.square(22),
          powerTextStyle: TopDashTextStyles.cardNumberXXS,
          powerTextStrokeWidth: 2,
          imageInset: const RelativeRect.fromLTRB(4, 3, 4, 24),
        );

  /// XS size.
  const GameCardSize.xs()
      : this(
          size: TopDashCardSizes.xs,
          badgeSize: const Size.square(41),
          titleTextStyle: TopDashTextStyles.cardTitleXS,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionXS,
          powerTextStyle: TopDashTextStyles.cardNumberXS,
          powerTextStrokeWidth: 2,
          imageInset: const RelativeRect.fromLTRB(8, 6, 8, 44),
        );

  /// SM size.
  const GameCardSize.sm()
      : this(
          size: TopDashCardSizes.sm,
          badgeSize: const Size.square(55),
          titleTextStyle: TopDashTextStyles.cardTitleSM,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionSM,
          powerTextStyle: TopDashTextStyles.cardNumberSM,
          powerTextStrokeWidth: 2,
          imageInset: const RelativeRect.fromLTRB(12, 10, 12, 60),
        );

  /// MD size.
  const GameCardSize.md()
      : this(
          size: TopDashCardSizes.md,
          badgeSize: const Size.square(70),
          titleTextStyle: TopDashTextStyles.cardTitleMD,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionMD,
          powerTextStyle: TopDashTextStyles.cardNumberMD,
          powerTextStrokeWidth: 3,
          imageInset: const RelativeRect.fromLTRB(14, 12, 14, 74),
        );

  /// LG size.
  const GameCardSize.lg()
      : this(
          size: TopDashCardSizes.lg,
          badgeSize: const Size.square(89),
          titleTextStyle: TopDashTextStyles.cardTitleLG,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionLG,
          powerTextStyle: TopDashTextStyles.cardNumberLG,
          powerTextStrokeWidth: 4,
          imageInset: const RelativeRect.fromLTRB(18, 14, 18, 96),
        );

  /// XL size.
  const GameCardSize.xl()
      : this(
          size: TopDashCardSizes.xl,
          badgeSize: const Size.square(110),
          titleTextStyle: TopDashTextStyles.cardTitleXL,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionXL,
          powerTextStyle: TopDashTextStyles.cardNumberXL,
          powerTextStrokeWidth: 4,
          imageInset: const RelativeRect.fromLTRB(20, 16, 20, 116),
        );

  /// XXL size.
  const GameCardSize.xxl()
      : this(
          size: TopDashCardSizes.xxl,
          badgeSize: const Size.square(130),
          titleTextStyle: TopDashTextStyles.cardTitleXXL,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionXXL,
          powerTextStyle: TopDashTextStyles.cardNumberXXL,
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

  @override
  List<Object?> get props => [
        size,
        descriptionTextStyle,
        titleTextStyle,
        imageInset,
      ];
}

/// {@template game_card}
/// Top Dash Game Card.
/// {@endtemplate}
class GameCard extends StatelessWidget {
  /// {@macro game_card}
  const GameCard({
    required this.image,
    required this.name,
    required this.suitName,
    required this.power,
    required this.description,
    this.size = const GameCardSize.lg(),
    this.isRare = false,
    this.overlay,
    this.tilt = Offset.zero,
    @visibleForTesting this.package = 'top_dash_ui',
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
    final cardBody = Stack(
      children: [
        Positioned.fromRelativeRect(
          rect: size.imageInset,
          child: Image.network(image),
        ),
        Positioned.fill(
          child: Image.asset(cardFrame),
        ),
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
                              color: TopDashColors.seedBlack,
                            ),
                          ],
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = size.powerTextStrokeWidth
                            ..color = TopDashColors.seedBlack,
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
            style: size.titleTextStyle.copyWith(
              color: TopDashColors.seedBlack,
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
                  color: TopDashColors.seedBlack,
                ),
              ),
            ),
          ),
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
            child: isRare
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * 0.075),
                    child: FoilShader(
                      package: package,
                      dx: tilt.dx,
                      dy: tilt.dy,
                      child: cardBody,
                    ),
                  )
                : cardBody,
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
