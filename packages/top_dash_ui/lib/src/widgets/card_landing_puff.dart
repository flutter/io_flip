import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';

/// {@template card_landing}
/// A widget that renders a [SpriteAnimation] for the card landing effect.
/// {@endtemplate}
class CardLandingPuff extends StatelessWidget {
  /// {@macro card_landing}
  const CardLandingPuff({
    super.key,
    this.height = 500,
    this.width = 500,
    this.playing = false,
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

  ///
  final bool playing;

  /// Optional callback to be called when the animation is complete.
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();

    return SizedBox(
      height: height,
      width: width,
      child: Offstage(
        offstage: !playing,
        child: SpriteAnimationWidget.asset(
          playing: playing,
          path: Assets.images.cardLanding.keyName,
          images: images,
          anchor: Anchor.center,
          onComplete: onComplete,
          data: SpriteAnimationData.sequenced(
            amount: 12,
            amountPerRow: 4,
            textureSize: Vector2(496, 698),
            stepTime: 0.04,
            loop: false,
          ),
        ),
      ),
    );
  }
}
