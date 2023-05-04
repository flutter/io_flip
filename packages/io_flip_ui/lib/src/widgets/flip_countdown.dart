import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:provider/provider.dart';

/// {@template flip_countdown}
/// A widget that renders a [SpriteAnimation] for the card flip countdown.
/// {@endtemplate}
class FlipCountdown extends StatefulWidget {
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
  State<StatefulWidget> createState() => _FlipCountdownState();
}

class _FlipCountdownState extends State<FlipCountdown> {
  late final ValueNotifier<SpriteAnimationWidget> _animationNotifier;

  @override
  void initState() {
    super.initState();
    _createAnimationWidget();
  }

  void _createAnimationWidget() {
    final images = context.read<Images>();
    _animationNotifier = ValueNotifier<SpriteAnimationWidget>(
      SpriteAnimationWidget.asset(
        path: Assets.images.flipCountdown.keyName,
        images: images,
        anchor: Anchor.center,
        onComplete: widget.onComplete,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ValueListenableBuilder<SpriteAnimationWidget>(
        valueListenable: _animationNotifier,
        builder: (_, animation, __) => animation,
      ),
    );
  }
}
