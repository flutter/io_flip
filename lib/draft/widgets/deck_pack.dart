import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/gen/assets.gen.dart';

class DeckPack extends StatefulWidget {
  const DeckPack({
    required this.child,
    this.size = double.infinity,
    super.key,
  });

  final Widget child;
  final double size;

  @override
  State<DeckPack> createState() => _DeckPackState();
}

class _DeckPackState extends State<DeckPack> {
  bool underlayVisible = false;
  bool isAnimationPlaying = false;
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
    ).then((spriteAnimation) {
      spriteAnimation.loop = true;
      setState(() {
        final ticker = spriteAnimation.ticker();
        anim = SpriteAnimationWidget(
          animation: spriteAnimation,
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
            if (ticker.isLastFrame) {
              setState(() {
                underlayVisible = false;
              });
            }
          };
      });
      spriteAnimation.ticker();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final images = context.watch<Images>();
    _beginAnimation(images);
    super.didChangeDependencies();
  }

  void _beginAnimation(Images images) {
    setState(() {
      isAnimationPlaying = true;
      underlayVisible = false;
    });

    setState(() {
      isAnimationPlaying = true;
      underlayVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (anim == null) return Container();

    return SizedBox.square(
      dimension: widget.size,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AspectRatio(
              // Aspect ratio of card
              aspectRatio: 260 / 380,
              child: Offstage(
                offstage: !underlayVisible,
                child: _StretchAnimation(
                  animating: underlayVisible,
                  child: Center(
                    child: widget.child,
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox.square(
                  dimension: 0,
                  child: OverflowBox(
                    maxWidth: constraints.maxWidth / 0.247,
                    maxHeight: constraints.maxHeight / 0.311,
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
  _StretchAnimation({
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
