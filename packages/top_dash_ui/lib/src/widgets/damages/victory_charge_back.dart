import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// {@template victory_charge_back}
/// A widget that renders a [SpriteAnimation] for the victory charge
/// behind the card.
/// {@endtemplate}
class VictoryChargeBack extends StatelessWidget {
  /// {@macro victory_charge_back}
  const VictoryChargeBack(
    this.path, {
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

  /// Path of the asset containing the sprite sheet.
  final String path;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();

    return SizedBox(
      height: height,
      width: width,
      child: SpriteAnimationWidget.asset(
        path: path,
        images: images,
        anchor: Anchor.center,
        onComplete: onComplete,
        data: SpriteAnimationData.sequenced(
          amount: 18,
          amountPerRow: 6,
          textureSize: Vector2(607, 695),
          stepTime: 0.04,
          loop: false,
        ),
      ),
    );
  }
}
