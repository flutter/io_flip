import 'dart:math' as math;

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class DeckPack extends StatefulWidget {
  const DeckPack({
    required this.child,
    required this.onComplete,
    required this.size,
    this.deviceInfoAware = deviceInfoAwareAsset,
    super.key,
  });

  final Widget child;
  final Size size;
  final VoidCallback onComplete;
  final DeviceInfoAwareAsset<Widget> deviceInfoAware;

  @override
  State<DeckPack> createState() => DeckPackState();
}

@visibleForTesting
class DeckPackState extends State<DeckPack> {
  Widget? _deckPackAnimation;
  bool _underlayVisible = false;
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();

    widget
        .deviceInfoAware(
      predicate: isAndroid,
      asset: () => AnimatedDeckPack(
        onComplete: onComplete,
        onUnderlayVisible: onUnderlayVisible,
      ),
      orElse: () => SpriteAnimationDeckPack(
        onComplete: onComplete,
        onUnderlayVisible: onUnderlayVisible,
      ),
    )
        .then((widget) {
      setState(() {
        _deckPackAnimation = widget;
      });
    });
  }

  void onComplete() {
    widget.onComplete();
    setState(() {
      _isAnimationComplete = true;
    });
  }

  void onUnderlayVisible() {
    setState(() {
      _underlayVisible = true;
    });
    context.read<AudioController>().playSfx(Assets.sfx.deckOpen);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: widget.size,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (_isAnimationComplete)
              widget.child
            else
              AspectRatio(
                // Aspect ratio of card
                aspectRatio: widget.size.aspectRatio,
                child: Offstage(
                  offstage: !_underlayVisible,
                  child: StretchAnimation(
                    animating: _underlayVisible,
                    child: Center(child: widget.child),
                  ),
                ),
              ),
            if (_deckPackAnimation != null) _deckPackAnimation!,
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class AnimatedDeckPack extends StatefulWidget {
  const AnimatedDeckPack({
    required this.onComplete,
    required this.onUnderlayVisible,
    super.key,
  });

  final VoidCallback onComplete;
  final VoidCallback onUnderlayVisible;

  @override
  State<AnimatedDeckPack> createState() => AnimatedDeckPackState();
}

@visibleForTesting
class AnimatedDeckPackState extends State<AnimatedDeckPack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var _underlayVisibleCalled = false;
  final animatable = TweenSequence<Matrix4>([
    TweenSequenceItem(
      tween: TransformTween(
        beginScale: 0.5,
        beginTranslateZ: 300,
        beginRotateY: -math.pi,
      ),
      weight: 0.25,
    ),
    for (var i = 0; i < 5; i++) ...[
      TweenSequenceItem(
        tween: TransformTween(
          endRotateZ: -math.pi / 60 - (i * math.pi / 60),
        ),
        weight: 0.15 - i * 0.01,
      ),
      TweenSequenceItem(
        tween: TransformTween(
          endRotateZ: math.pi / 60 + (i * math.pi / 60),
        ),
        weight: 0.15 - i * 0.01,
      ),
    ],
    TweenSequenceItem(
      tween: TransformTween(
        endTranslateZ: -300,
        endRotateX: math.pi / 4,
      ),
      weight: 0.3,
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(() {
        if (!_underlayVisibleCalled && _controller.value > 0.95) {
          widget.onUnderlayVisible();

          setState(() {
            _underlayVisibleCalled = true;
          });
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete();
        }
      })
      ..forward();
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
      builder: (context, child) {
        return Transform(
          transform: animatable.evaluate(_controller),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _underlayVisibleCalled ? 0 : 1,
        child: Assets.images.mobile.deckPackStill.image(),
      ),
    );
  }
}

@visibleForTesting
class SpriteAnimationDeckPack extends StatefulWidget {
  const SpriteAnimationDeckPack({
    required this.onComplete,
    required this.onUnderlayVisible,
    super.key,
  });

  final VoidCallback onComplete;
  final VoidCallback onUnderlayVisible;

  @override
  State<SpriteAnimationDeckPack> createState() =>
      SpriteAnimationDeckPackState();
}

@visibleForTesting
class SpriteAnimationDeckPackState extends State<SpriteAnimationDeckPack> {
  late final Images images;
  final asset = platformAwareAsset(
    desktop: Assets.images.desktop.frontPack.keyName,
    mobile: Assets.images.mobile.frontPack.keyName,
  );
  Widget? anim;

  @override
  void initState() {
    super.initState();
    images = context.read<Images>();
    setupAnimation();
  }

  @override
  void dispose() {
    images.clear(asset);
    super.dispose();
  }

  Future<void> setupAnimation() async {
    final data = SpriteAnimationData.sequenced(
      amount: 56,
      amountPerRow: platformAwareAsset(desktop: 7, mobile: 8),
      textureSize: platformAwareAsset(
        desktop: Vector2(1050, 1219),
        mobile: Vector2(750, 871),
      ),
      stepTime: 0.04,
      loop: false,
    );
    await SpriteAnimation.load(
      asset,
      data,
      images: images,
    ).then((animation) {
      if (!mounted) return;
      final ticker = animation.ticker()
        ..onFrame = onFrame
        ..completed.then((_) => widget.onComplete());
      setState(() {
        anim = SpriteAnimationWidget(
          animation: animation,
          animationTicker: ticker,
        );
      });
    });
  }

  void onFrame(int currentFrame) {
    if (currentFrame == 29) {
      widget.onUnderlayVisible();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (anim == null) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        // The shrink is here to "hide" the size of the deck pack
        // animation as we want the DeckPack to size to the card and
        // not the animation size.
        return SizedBox.shrink(
          child: OverflowBox(
            maxWidth: constraints.maxWidth / 0.272,
            maxHeight: constraints.maxHeight / 0.344,
            child: Transform.translate(
              offset: Offset(0, constraints.maxHeight * 0.16),
              child: Center(
                child: AspectRatio(
                  // Aspect ratio of texture
                  aspectRatio: 1050 / 1219,
                  child: SizedBox.expand(child: anim),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
