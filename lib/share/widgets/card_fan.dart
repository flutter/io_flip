import 'dart:math' as math;

import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

class CardFan extends StatelessWidget {
  const CardFan({
    required this.cards,
    super.key,
  });

  final List<Card> cards;

  @override
  Widget build(BuildContext context) {
    const container = 360.0;
    const size = GameCardSize.sm();
    final offset = size.width / 1.4;
    final center = (container - size.width) / 2;
    final gameCards = cards
        .map(
          (card) => GameCard(
            size: size,
            description: card.description,
            image: card.image,
            name: card.name,
            suitName: card.suit.name,
            power: card.power,
          ),
        )
        .toList();
    return SizedBox(
      height: 215,
      width: container,
      child: Stack(
        children: [
          Positioned(
            top: 12,
            left: center - offset,
            child: Transform.rotate(
              angle: -math.pi / 16.0,
              child: gameCards[0],
            ),
          ),
          Positioned(
            top: 0,
            left: center,
            child: gameCards[1],
          ),
          Positioned(
            top: 12,
            left: center + offset,
            child: Transform.rotate(
              angle: math.pi / 16.0,
              child: gameCards[2],
            ),
          ),
        ],
      ),
    );
  }
}
