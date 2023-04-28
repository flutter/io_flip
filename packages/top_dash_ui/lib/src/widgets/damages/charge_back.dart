import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template charge_back}
/// A widget that renders a [SpriteAnimation] for the charge effect in front
/// of the card.
/// {@endtemplate}
class ChargeBack extends StatelessWidget {
  /// {@macro charge_back}
  const ChargeBack(
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
    final width = 1.72 * size.width;
    final x = 0.21 * width;
    final y = 0.2 * height;

    return Transform.translate(
      offset: -Offset(x, y),
      child: SizedBox(
        height: height,
        width: width,
        child: ColoredBox(
          color: Colors.red.withOpacity(0.3),
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
      ),
    );
  }
}
