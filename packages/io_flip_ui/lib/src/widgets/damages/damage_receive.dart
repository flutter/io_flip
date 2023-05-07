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

class _MobileAnimationState extends State<_MobileAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> animationControllers;

  var _stepCounter = 1;

  @override
  void initState() {
    super.initState();
    animationControllers = List.generate(
      2,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750),
      ),
    );
    animationControllers.first
      ..forward()
      ..repeat();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => animationControllers.last
        ..forward()
        ..addStatusListener(
          (status) {
            if (status == AnimationStatus.completed) {
              _stepCounter--;
              if (_stepCounter == 0) {
                animationControllers.first.stop();
                animationControllers.last.stop();
                widget.onComplete?.call();
              } else {
                animationControllers.last
                  ..reset()
                  ..forward();
              }
            }
          },
        ),
    );
  }

  @override
  void dispose() {
    animationControllers.first.dispose();
    animationControllers.last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          _AnimatedRing(
            animationController: animationControllers.first,
            index: 1,
            color: widget.animationColor,
            size: widget.width,
          ),
          _AnimatedRing(
            animationController: animationControllers.last,
            index: 3,
            color: widget.animationColor,
            size: widget.width,
          ),
        ],
      ),
    );
  }
}

class _AnimatedRing extends StatelessWidget {
  const _AnimatedRing({
    required this.animationController,
    required this.index,
    required this.color,
    required this.size,
  });

  final AnimationController animationController;
  final int index;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          final scale = animationController.value;
          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.transparent, color.withOpacity(1 - scale)],
                ),
                borderRadius: BorderRadius.circular(size / 2),
              ),
              width: size / 4,
              height: size / 4,
            ),
          );
        },
      ),
    );
  }
}
