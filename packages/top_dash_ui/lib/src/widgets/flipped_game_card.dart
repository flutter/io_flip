import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template flipped_game_card}
/// Top Dash Flipped Game Card.
/// {@endtemplate}
class FlippedGameCard extends StatelessWidget {
  /// {@macro flipped_game_card}
  const FlippedGameCard({
    super.key,
    this.width,
    this.height,
  });

  /// Width
  final double? width;

  /// Height
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TopDashColors.seedBlue,
        border: Border.all(
          width: 2,
          color: TopDashColors.seedPaletteBlue70,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      width: width,
      height: height,
    );
  }
}
