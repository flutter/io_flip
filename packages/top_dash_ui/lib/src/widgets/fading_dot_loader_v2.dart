import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template fading_dot_indicator}
/// A loading indicator with 3 fading dots.
/// {@endtemplate}
class FadingDotLoaderV2 extends StatefulWidget {
  /// {@macro fading_dot_indicator}
  const FadingDotLoaderV2({super.key, this.numberOfDots = 3});
  final int numberOfDots;

  @override
  State<FadingDotLoaderV2> createState() => _FadingDotLoaderV2State();
}

class _FadingDotLoaderV2State extends State<FadingDotLoaderV2>
    with TickerProviderStateMixin {
  // late final List<AnimationController> animationControllers;
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
          _AnimatedDot(index: i, animationController: animationController),
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
    required this.animationController,
    required this.index,
  });

  final Animation<double> animationController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        final t = (animationController.value - (index * .2)) % 1;
        final progress = 1 - (2 * (t - .5).abs());
        final opacity = .4 + (progress * .6);
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Container(
        width: TopDashSpacing.lg,
        height: TopDashSpacing.lg,
        decoration: const BoxDecoration(
          color: TopDashColors.mainBlue,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
