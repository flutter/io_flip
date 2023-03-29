import 'package:flutter/material.dart' hide Card;
import 'package:top_dash_ui/top_dash_ui.dart';

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
    this.isRare = false,
    this.width,
    this.height,
    this.overlay,
    super.key,
  });

  /// [CardOverlayType] type of overlay or null if no overlay
  final CardOverlayType? overlay;

  /// Optional width
  final double? width;

  /// Optional height
  final double? height;

  /// Image
  final String image;

  /// Name
  final String name;

  /// Suit name
  final String suitName;

  ///Power
  final int power;

  /// Is a rare card
  final bool isRare;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isRare ? TopDashColors.gold : TopDashColors.mainBlue,
            border: Border.all(
              width: 2,
              color: TopDashColors.lightBlue60,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: width,
          height: height,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(name),
              const SizedBox(height: 8),
              Text(
                suitName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Image.network(
                image,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    power.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (overlay != null) CardOverlay.ofType(overlay!, width, height)
      ],
    );
  }
}
