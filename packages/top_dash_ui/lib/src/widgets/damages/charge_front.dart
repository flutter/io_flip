import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/top_dash_ui.dart';
import 'package:provider/provider.dart';

/// {@template charge_front}
/// A widget that renders a [SpriteAnimation] for the charge effect in the back
/// of the card.
/// {@endtemplate}
class ChargeFront extends StatelessWidget {
  /// {@macro charge_front}
  const ChargeFront(
    this.path, {
    required this.size,
    super.key,
    this.onComplete,
  });

  /// The size of the card.
  final GameCardSize size;

  /// Optional callback to be called when the animation is complete.
  final VoidCallback? onComplete;

  /// Path of the asset containing the sprite sheet.
  final String path;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();
    final height = 1.538 * size.height;
    final width = 1.89 * size.width;
    final x = 0.45 * size.width;
    final y = 0.31 * size.height;

    return Transform.translate(
      offset: -Offset(x, y),
      child: SizedBox(
        height: height,
        width: width,
        child: SpriteAnimationWidget.asset(
          path: path,
          images: images,
          anchor: Anchor.center,
          onComplete: onComplete,
          data: SpriteAnimationData.sequenced(
            amount: 20,
            amountPerRow: 5,
            textureSize: Vector2(658, 860),
            stepTime: 0.04,
            loop: false,
          ),
        ),
      ),
    );
  }
}
