import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template fading_dot_indicator}
/// A loading indicator with 3 fading dots.
/// {@endtemplate}
class FadingDotLoader extends StatefulWidget {
  /// {@macro fading_dot_indicator}
  const FadingDotLoader({super.key, this.numberOfDots = 3});

  /// The number of dots in the loader.
  final int numberOfDots;

  @override
  State<FadingDotLoader> createState() => _FadingDotLoaderState();
}

class _FadingDotLoaderState extends State<FadingDotLoader>
    with TickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    final length = Duration(milliseconds: 460 * widget.numberOfDots);
    animationController = AnimationController(vsync: this, duration: length)
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.numberOfDots; i++) ...[
          _AnimatedDot(index: i, animation: animationController),
          if (i < widget.numberOfDots - 1)
            const SizedBox(width: TopDashSpacing.xs)
        ],
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({
    required this.animation,
    required this.index,
  });

  final Animation<double> animation;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        // Calculates the animation controller value with an offset based on the
        // dot's index and limits the new value between the range (0, 1)
        final offset = (animation.value - (index * .2)) % 1;
        // Takes the new value that goes 0 -> 1, and converts it to move 0->1->0
        final progress = 1 - (2 * (offset - .5).abs());
        // Calculates opacity with a floor and ceiling of 40% and 100%
        final opacity = (progress * .6) + .4;

        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Container(
        width: TopDashSpacing.lg,
        height: TopDashSpacing.lg,
        decoration: const BoxDecoration(
          color: TopDashColors.seedPaletteBlue50,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
