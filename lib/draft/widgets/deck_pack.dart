import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/gen/assets.gen.dart';

typedef DeckPackChildBuilder = Widget Function({
  required bool isAnimating,
});

class DeckPack extends StatefulWidget {
  const DeckPack({
    required this.builder,
    this.size = double.infinity,
    super.key,
  });

  final DeckPackChildBuilder builder;
  final double size;

  @override
  State<DeckPack> createState() => _DeckPackState();
}

class _DeckPackState extends State<DeckPack> {
  bool underlayVisible = false;
  bool isAnimationComplete = false;
  Widget? anim;

  @override
  void initState() {
    final data = SpriteAnimationData.sequenced(
      amount: 56,
      amountPerRow: 7,
      textureSize: Vector2(1050, 1219),
      stepTime: 0.04,
      loop: false,
    );
    SpriteAnimation.load(
      Assets.images.frontPack.keyName,
      data,
      images: context.read<Images>(),
    ).then((animation) {
      setState(() {
        final ticker = animation.ticker();
        anim = SpriteAnimationWidget(
          animation: animation,
          animationTicker: ticker,
        );
        ticker
          ..onComplete = () {
            setState(() {
              underlayVisible = false;
            });
          }
          ..onFrame = (frame) {
            if (frame == 29) {
              setState(() {
                underlayVisible = true;
              });
            }

            if (frame == animation.frames.length - 1) {
              setState(() {
                isAnimationComplete = true;
              });
            }
          };
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (anim == null) return SizedBox.square(dimension: widget.size);
    final child = widget.builder(isAnimating: !isAnimationComplete);
    return SizedBox.square(
      dimension: widget.size,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (isAnimationComplete) child,
            if (!isAnimationComplete)
              AspectRatio(
                // Aspect ratio of card
                aspectRatio: 260 / 380,
                child: Offstage(
                  offstage: !underlayVisible,
                  child: _StretchAnimation(
                    animating: underlayVisible,
                    child: Center(child: child),
                  ),
                ),
              ),
            LayoutBuilder(
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
            ),
          ],
        ),
      ),
    );
  }
}

class _StretchAnimation extends StatefulWidget {
  const _StretchAnimation({
    required this.child,
    this.animating = false,
  });

  final Widget child;
  final bool animating;

  @override
  State<_StretchAnimation> createState() => _StretchAnimationState();
}

class _StretchAnimationState extends State<_StretchAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
    lowerBound: 0.35,
  );
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

  @override
  void initState() {
    if (widget.animating) {
      _controller.forward();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _StretchAnimation oldWidget) {
    if (oldWidget.animating != widget.animating) {
      if (widget.animating) {
        _controller
          ..reset()
          ..forward();
      } else {
        _controller.stop();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
