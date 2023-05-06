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
  var _scale = 0.0;
  var _step = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onComplete?.call();
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
    return AnimatedScale(
      duration: const Duration(milliseconds: 400),
      onEnd: _onComplete,
      scale: _scale,
      child: ColoredBox(
        //color: widget.animationColor,
        color: Colors.transparent,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }
}
