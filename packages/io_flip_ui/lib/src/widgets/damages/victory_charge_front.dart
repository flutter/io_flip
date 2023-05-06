import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

/// {@template victory_charge_front}
/// A widget that renders a [SpriteAnimation] for the victory charge in front
/// of the card
/// {@endtemplate}
class VictoryChargeFront extends StatelessWidget {
  /// {@macro victory_charge_front}
  const VictoryChargeFront(
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

  /// The color of the animation, used on mobile animation.
  final Color animationColor;

  /// Size of the assets to use, large or small
  final AssetSize assetSize;

  @override
  Widget build(BuildContext context) {
    final images = context.read<Images>();
    final width = 1.5 * size.width;
    final height = 1.22 * size.height;
    final textureSize = Vector2(607, 695);

    if (assetSize == AssetSize.large) {
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
              amount: 18,
              amountPerRow: 6,
              textureSize: textureSize,
              stepTime: 0.04,
              loop: false,
            ),
          ),
        ),
      ),
    );
    } else {
      return _MobileAnimation(
        onComplete: onComplete,
        animationColor: animationColor,
        width: width,
        height: height,
        cardSize: size,
      );
    }
  }
}

class _MobileAnimation extends StatefulWidget {
  const _MobileAnimation({
    required this.onComplete,
    required this.animationColor,
    required this.cardSize,
    required this.width,
    required this.height,
  });

  final VoidCallback? onComplete;
  final Color animationColor;
  final GameCardSize cardSize;
  final double width;
  final double height;

  @override
  State<_MobileAnimation> createState() => _MobileAnimationState();
}

class _MobileAnimationState extends State<_MobileAnimation> {
  late var _top = widget.cardSize.height;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _top = 0;
      });
    });
  }

  void _onComplete() {
      widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -.8),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            AnimatedPositioned(
              onEnd: _onComplete,
              duration: const Duration(milliseconds: 400),
              top: _top,
              child: Opacity(
                opacity: .6,
                child: Container(
                  width: widget.cardSize.width * 1.3,
                  height: widget.cardSize.height * .02,
                  decoration: BoxDecoration(
                    color: widget.animationColor,
                    borderRadius: BorderRadius.circular(
                      widget.cardSize.width / 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.animationColor,
                        blurRadius: widget.cardSize.height * .06,
                        spreadRadius: widget.cardSize.height * .05,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
