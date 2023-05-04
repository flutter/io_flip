import 'package:flutter/material.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

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
      child: Assets.images.cardFrames.cardBack.image(
        fit: BoxFit.cover,
      ),
    );
  }
}
