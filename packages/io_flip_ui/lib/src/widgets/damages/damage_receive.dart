import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

/// {@template damage_receive}
/// A widget that renders a [SpriteAnimation] for the damages received.
/// {@endtemplate}
class DamageReceive extends StatelessWidget {
  /// {@macro damage_receive}
  const DamageReceive(
    this.path, {
    required this.size,
    required this.assetSize,
    super.key,
    this.onComplete,
  });

  /// The size of the card.
  final GameCardSize size;

  /// Optional callback to be called when the animation is complete.
  final VoidCallback? onComplete;

  /// Path of the asset containing the sprite sheet.
  final String path;

  /// Size of the assets to use, large or small
  final AssetSize assetSize;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();
    final height = 1.6 * size.height;
    final width = 1.6 * size.width;

    return SizedBox(
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
          textureSize: assetSize == AssetSize.large
              ? Vector2(499.5, 509)
              : Vector2(298, 305),
          stepTime: 0.04,
          loop: false,
        ),
      ),
    );
  }
}
