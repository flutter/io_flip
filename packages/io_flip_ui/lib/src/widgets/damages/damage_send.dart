import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

/// {@template damage_send}
/// A widget that renders a [SpriteAnimation] for the damages sent.
/// {@endtemplate}
class DamageSend extends StatelessWidget {
  /// {@macro damage_send}
  const DamageSend(
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

  /// path of the asset containing the sprite sheet
  final String path;

  /// Size of the assets to use, large or small
  final AssetSize assetSize;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();
    final height = size.height;
    final width = size.width;

    return SizedBox(
      height: height,
      width: width,
      child: RotatedBox(
        quarterTurns: 2,
        child: SpriteAnimationWidget.asset(
          path: path,
          images: images,
          anchor: Anchor.center,
          onComplete: onComplete,
          data: SpriteAnimationData.sequenced(
            amount: 18,
            amountPerRow: 6,
            textureSize: assetSize == AssetSize.large
                ? Vector2(568, 683)
                : Vector2(341, 410),
            stepTime: 0.04,
            loop: false,
          ),
        ),
      ),
    );
  }
}
