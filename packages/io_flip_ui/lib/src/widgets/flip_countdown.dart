import 'dart:math';
import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:provider/provider.dart';

/// {@template flip_countdown}
/// A widget that renders a [SpriteAnimation] for the card flip countdown.
/// {@endtemplate}
class FlipCountdown extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isMobile =
        platform == TargetPlatform.iOS || platform == TargetPlatform.android;
    return SizedBox(
      height: height,
      width: width,
      child: isMobile
          ? _MobileFlipCountdown(
              key: const Key('flipCountdown_mobile'),
              onComplete: onComplete,
            )
          : _DesktopFlipCountdown(
              onComplete: onComplete,
            ),
    );
  }
}

class _MobileFlipCountdown extends StatefulWidget {
  const _MobileFlipCountdown({required this.onComplete, super.key});

  final VoidCallback? onComplete;

  @override
  State<_MobileFlipCountdown> createState() => _MobileFlipCountdownState();
}

class _MobileFlipCountdownState extends State<_MobileFlipCountdown>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final threePhase = CurveTween(
    curve: const Interval(0, 1 / 4, curve: Curves.easeOutBack),
  );
  final twoPhase = CurveTween(
    curve: const Interval(1 / 4, 2 / 4, curve: Curves.easeOutBack),
  );
  final onePhase = CurveTween(
    curve: const Interval(2 / 4, 3 / 4, curve: Curves.easeOutBack),
  );
  final flipPhase = CurveTween(
    curve: const Interval(3 / 4, 1, curve: Curves.easeOutBack),
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      })
      ..forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t3 = threePhase.evaluate(_controller);
        final t2 = twoPhase.evaluate(_controller);
        final t1 = onePhase.evaluate(_controller);
        final tFlip = flipPhase.evaluate(_controller);

        return Stack(
          alignment: Alignment.center,
          children: [
            Offstage(
              offstage: _controller.value > 1 / 4,
              child: _MobileFlipCountdownPhase(
                t: t3,
                image: Assets.images.flipCountdown.mobile.flipCountdown3
                    .image(width: 200),
              ),
            ),
            Offstage(
              offstage: _controller.value <= 1 / 4 || _controller.value > 2 / 4,
              child: _MobileFlipCountdownPhase(
                t: t2,
                image: Assets.images.flipCountdown.mobile.flipCountdown2
                    .image(width: 200),
              ),
            ),
            Offstage(
              offstage: _controller.value <= 2 / 4 || _controller.value > 3 / 4,
              child: _MobileFlipCountdownPhase(
                t: t1,
                image: Assets.images.flipCountdown.mobile.flipCountdown1
                    .image(width: 200),
              ),
            ),
            Offstage(
              offstage: _controller.value <= 3 / 4 || _controller.value == 1,
              child: _MobileFlipCountdownPhase(
                t: tFlip,
                image: Assets.images.flipCountdown.mobile.flipCountdownFlip
                    .image(width: 500),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MobileFlipCountdownPhase extends StatelessWidget {
  const _MobileFlipCountdownPhase({
    required this.t,
    required this.image,
  });

  final double t;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateZ(lerpDouble(-pi / 12, 0, t)!)
        ..scale(lerpDouble(0.75, 1, t)),
      child: image,
    );
  }
}

class _DesktopFlipCountdown extends StatefulWidget {
  const _DesktopFlipCountdown({required this.onComplete});

  final VoidCallback? onComplete;

  @override
  State<_DesktopFlipCountdown> createState() => _DesktopFlipCountdownState();
}

class _DesktopFlipCountdownState extends State<_DesktopFlipCountdown> {
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
        path: Assets.images.flipCountdown.desktop.flipCountdown.keyName,
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
    return ValueListenableBuilder<SpriteAnimationWidget>(
      valueListenable: _animationNotifier,
      builder: (_, animation, __) => animation,
    );
  }
}
