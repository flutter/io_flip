import 'package:flutter/material.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template flipped_game_card}
/// Top Dash Flipped Game Card.
/// {@endtemplate}
class FlippedGameCard extends StatelessWidget {
  /// {@macro flipped_game_card}
  const FlippedGameCard({
    super.key,
    this.size = const GameCardSize.lg(),
  });

  /// Size of the card.
  final GameCardSize size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Image.asset(
        Assets.images.cardFrames.cardBack.keyName,
        fit: BoxFit.cover,
      ),
    );
  }
}
