import 'dart:math' as math;
import 'package:flutter/material.dart' hide Card;
import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template game_card_size}
/// A class that holds information about card dimensions.
/// {@endtemplate}
class GameCardSize {
  /// {@macro game_card_size}
  const GameCardSize({
    required this.size,
    required this.titleTextStyle,
    required this.descriptionTextStyle,
  });

  /// XS size.
  const GameCardSize.xs()
      : this(
          size: TopDashCardSizes.xs,
          titleTextStyle: TopDashTextStyles.cardTitleXS,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionXS,
        );

  /// SM size.
  const GameCardSize.sm()
      : this(
          size: TopDashCardSizes.sm,
          titleTextStyle: TopDashTextStyles.cardTitleSM,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionSM,
        );

  /// MD size.
  const GameCardSize.md()
      : this(
          size: TopDashCardSizes.md,
          titleTextStyle: TopDashTextStyles.cardTitleMD,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionMD,
        );

  /// LG size.
  const GameCardSize.lg()
      : this(
          size: TopDashCardSizes.lg,
          titleTextStyle: TopDashTextStyles.cardTitleLG,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionLG,
        );

  /// XL size.
  const GameCardSize.xl()
      : this(
          size: TopDashCardSizes.xl,
          titleTextStyle: TopDashTextStyles.cardTitleXL,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionXL,
        );

  /// XXL size.
  const GameCardSize.xxl()
      : this(
          size: TopDashCardSizes.xxl,
          titleTextStyle: TopDashTextStyles.cardTitleXXL,
          descriptionTextStyle: TopDashTextStyles.cardDescriptionXXL,
        );

  /// Size
  final Size size;

  /// Name text style
  final TextStyle titleTextStyle;

  /// Description text style
  final TextStyle descriptionTextStyle;

  /// Scale the card by the given rect.
  ///
  /// The card will scale in a proportionate way to the rect.
  /// It will use the biggest scale factor based on width or height.
  GameCardSize scaleByRect(Rect rect) {
    final widthFactor = size.width / rect.width;
    final heightFactor = size.height / rect.height;

    final factor = math.max(widthFactor, heightFactor);

    return GameCardSize(
      size: Size(size.width / factor, size.height / factor),
      titleTextStyle: titleTextStyle.copyWith(
        fontSize: titleTextStyle.fontSize! / factor,
      ),
      descriptionTextStyle: descriptionTextStyle.copyWith(
        fontSize: descriptionTextStyle.fontSize! / factor,
      ),
    );
  }
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

  String _mapSuitNameToAsset() {
    switch (suitName) {
      case 'fire':
        return Assets.images.cardFrames.cardFire.keyName;
      case 'water':
        return Assets.images.cardFrames.cardWater.keyName;
      case 'earth':
        return Assets.images.cardFrames.cardEarth.keyName;
      case 'air':
        return Assets.images.cardFrames.cardAir.keyName;
      case 'metal':
        return Assets.images.cardFrames.cardMetal.keyName;
      default:
        throw ArgumentError('Invalid suit name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: size.size.width,
          height: size.size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.size.width * 0.25),
                    topRight: Radius.circular(size.size.width * 0.25),
                  ),
                  child: Image.network(image),
                ),
              ),
              Positioned.fill(
                child: Image.asset(
                  _mapSuitNameToAsset(),
                  package: 'top_dash_ui',
                ),
              ),
              Align(
                alignment: const Alignment(.8, -.8),
                child: Text(
                  power.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Align(
                alignment: const Alignment(0, .45),
                child: Text(
                  name,
                  style: size.titleTextStyle.copyWith(
                    color: TopDashColors.seedBlack,
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, .85),
                child: SizedBox(
                  width: size.size.width * 0.8,
                  height: size.size.height * 0.2,
                  child: Center(
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
          ),
        ),
        if (overlay != null)
          CardOverlay.ofType(
            overlay!,
            size.size.width,
            size.size.height,
          )
      ],
    );
  }
}
