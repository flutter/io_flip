import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/widgets/card_overlay.dart';

enum CardOverlayType {
  win,
  lose,
  draw,
}

class GameCard extends StatelessWidget {
  const GameCard({
    required this.card,
    this.width,
    this.height,
    this.overlay,
    super.key,
  });

  final Card card;
  final CardOverlayType? overlay;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: card.rarity ? Colors.yellow.shade200 : Colors.blue.shade200,
            border: Border.all(
              width: 2,
              color: Colors.blue.shade100,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: width,
          height: height,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(card.name),
              const SizedBox(height: 8),
              Text(
                card.suit.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Image.network(
                card.image,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${card.power}',
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

class FlippedGameCard extends StatelessWidget {
  const FlippedGameCard({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        border: Border.all(
          width: 2,
          color: Colors.blue.shade200,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: width,
      height: height,
    );
  }
}
