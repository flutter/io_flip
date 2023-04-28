import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/gen/assets.gen.dart';

class DeckPack extends StatelessWidget {
  const DeckPack({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OverflowBox(
          alignment: Alignment.topCenter,
          maxHeight: constraints.maxHeight * 2,
          maxWidth: constraints.maxWidth * 2,
          child: _AnimatedDeck(child: child),
        );
      },
    );
  }
}

class _AnimatedDeck extends StatefulWidget {
  const _AnimatedDeck({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<_AnimatedDeck> createState() => _AnimatedDeckState();
}

class _AnimatedDeckState extends State<_AnimatedDeck> {
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
    // anim = SpriteAnimationWidget.asset(
    //   onComplete: () {
    //     _beginAnimation(images);
    //   },
    //   path: Assets.images.frontPack.keyName,
    //   images: images,
    //   anchor: Anchor.topCenter,
    //   // onComplete: onComplete,
    //   data: SpriteAnimationData.sequenced(
    //     amount: 56,
    //     amountPerRow: 7,
    //     textureSize: Vector2(1050, 1219),
    //     stepTime: 0.04,
    //     loop: false,
    //   ),
    // );
    setState(() {
      isAnimationPlaying = true;
      underlayVisible = false;
    });

    // Future<void>.delayed(const Duration(milliseconds: 1210)).then((value) {
    //   if (mounted) {
    //     setState(() {
    //       underlayVisible = true;
    //     });
    //   }
    // });

    setState(() {
      isAnimationPlaying = true;
      underlayVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const aspectRatio = 0.75;
    const height = 1200.0;

    const leftFactor = 0.38;
    const topFactor = .11;
    const bottomFactor = 0.38;

    if (anim == null) return Container();

    return AspectRatio(
      aspectRatio: 1050 / 1219,
      child: Stack(
        children: [
          Offstage(
            offstage: !underlayVisible,
            child: Align(
              alignment: const Alignment(-0.02, -0.65),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints.loose(
                      Size(
                        0.29 * constraints.maxWidth,
                        0.32 * constraints.maxHeight,
                      ),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                        ),
                      ),
                      child: Center(
                        child: _StretchAnimation(
                          animating: underlayVisible,
                          child: widget.child,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                ),
              ),
              child: anim,
            ),
          ),
        ],
      ),
    );

    return AspectRatio(
      aspectRatio: 1050 / 1219,
      child: Stack(
        children: [
          Offstage(
            offstage: !underlayVisible,
            child: Align(
              alignment: const Alignment(-0.02, -0.6),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints.loose(
                      Size(
                        0.29 * constraints.maxWidth,
                        0.36 * constraints.maxHeight,
                      ),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1050 / 1400,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                          ),
                        ),
                        child: Center(
                          child: _StretchAnimation(
                            animating: underlayVisible,
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: 1050 / 1219,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                ),
                child: anim,
              ),
            ),
          ),
        ],
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
