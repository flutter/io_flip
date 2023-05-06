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
    required this.animationColor,
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

  /// The color of the animation, used on mobile animation.
  final Color animationColor;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();
    final height = 1.6 * size.height;
    final width = 1.6 * size.width;

    if (assetSize == AssetSize.large) {
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
            textureSize: Vector2(499.5, 509),
            stepTime: 0.04,
            loop: false,
          ),
        ),
      );
    } else {
      return _MobileAnimation(
        onComplete: onComplete,
        animationColor: animationColor,
        width: width,
        height: height,
      );
    }
  }
}

class _MobileAnimation extends StatefulWidget {
  const _MobileAnimation({
    required this.onComplete,
    required this.animationColor,
    required this.width,
    required this.height,
  });

  final VoidCallback? onComplete;
  final Color animationColor;
  final double width;
  final double height;

  @override
  State<_MobileAnimation> createState() => _MobileAnimationState();
}

class _MobileAnimationState extends State<_MobileAnimation> {
  var _scale = 1.0;
  var _step = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _scale = 1.6;
      });
    });
  }

  void _onComplete() {
    if (_step == 0) {
      setState(() {
        _scale = 1;
        _step = 1;
      });
    } else {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AnimatedScale(
        duration: const Duration(milliseconds: 400),
        onEnd: _onComplete,
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: widget.animationColor,
            borderRadius: BorderRadius.circular(widget.width / 2),
          ),
          width: widget.width / 10,
          height: widget.height / 10,
        ),
      ),
    );
  }
}
