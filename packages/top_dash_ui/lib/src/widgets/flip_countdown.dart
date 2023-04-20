import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';

/// {@template flip_countdown}
/// A widget that renders a [SpriteAnimation] for the card flip countdown.
/// {@endtemplate}
class FlipCountdown extends StatelessWidget {
  /// {@macro flip_countdown}
  const FlipCountdown({
    super.key,
    this.height = 500,
    this.width = 500,
    this.onComplete,
  });

  /// The height of the widget.
  ///
  /// Defaults to `500`.
  final double height;

  /// The width of the widget.
  ///
  /// Defaults to `500`.
  final double width;

  /// Optional callback to be called when the animation is complete.
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();

    return SizedBox(
      height: height,
      width: width,
      child: SpriteAnimationWidget.asset(
        path: Assets.images.flipCountdown.keyName,
        images: images,
        anchor: Anchor.center,
        onComplete: onComplete,
        data: SpriteAnimationData.sequenced(
          amount: 60,
          amountPerRow: 6,
          textureSize: Vector2(1100, 750),
          stepTime: 0.04,
          loop: false,
        ),
      ),
    );
  }
}
