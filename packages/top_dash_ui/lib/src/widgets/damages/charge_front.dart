import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template charge_front}
/// A widget that renders a [SpriteAnimation] for the charge effect in the back
/// of the card.
/// {@endtemplate}
class ChargeFront extends StatelessWidget {
  /// {@macro charge_front}
  const ChargeFront(
    this.path, {
    super.key,
    required this.size,
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

    return SizedBox(
      height: 1.517 * size.height,
      width: 1.625 * size.width,
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
    );
  }
}
