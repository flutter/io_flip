import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

/// {@template charge_back}
/// A widget that renders a [SpriteAnimation] for the charge effect in front
/// of the card.
/// {@endtemplate}
class ChargeBack extends StatelessWidget {
  /// {@macro charge_back}
  const ChargeBack(
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
    final width = 1.64 * size.width;
    final height = 1.53 * size.height;
    final textureSize =
        assetSize == AssetSize.large ? Vector2(658, 860) : Vector2(395, 516);

    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: textureSize.x,
          height: textureSize.y,
          child: SpriteAnimationWidget.asset(
            path: path,
            images: images,
            anchor: Anchor.center,
            onComplete: onComplete,
            data: SpriteAnimationData.sequenced(
              amount: 20,
              amountPerRow: 5,
              textureSize: textureSize,
              stepTime: 0.04,
              loop: false,
            ),
          ),
        ),
      ),
    );
  }
}
