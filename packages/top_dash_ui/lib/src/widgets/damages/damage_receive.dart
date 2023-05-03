import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template damage_receive}
/// A widget that renders a [SpriteAnimation] for the damages received.
/// {@endtemplate}
class DamageReceive extends StatelessWidget {
  /// {@macro damage_receive}
  const DamageReceive(
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
    final height = 1.6 * size.height;
    final width = 1.6 * size.width;
    final x = 0.3 * size.width;
    final y = 0.3 * size.height;

    return Transform.translate(
      offset: Offset(x, y),
      child: SizedBox(
        height: height,
        width: width,
        child: SpriteAnimationWidget.asset(
          path: path,
          images: images,
          anchor: Anchor.center,
          onComplete: onComplete,
          data: SpriteAnimationData.sequenced(
            amount: 16,
            amountPerRow: 4,
            textureSize: Vector2(499.5, 509),
            stepTime: 0.04,
            loop: false,
          ),
        ),
      ),
    );
  }
}
