import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template fading_dot_indicator}
/// A loading indicator with 3 fading dots.
/// {@endtemplate}
class FadingDotLoader extends StatefulWidget {
  /// {@macro fading_dot_indicator}
  const FadingDotLoader({super.key});

  @override
  State<FadingDotLoader> createState() => _FadingDotLoaderState();
}

class _FadingDotLoaderState extends State<FadingDotLoader>
    with TickerProviderStateMixin {
  late final List<AnimationController> animationControllers;

  @override
  void initState() {
    super.initState();
    const length = Duration(milliseconds: 700);
    const delay = Duration(milliseconds: 300);
    animationControllers = [
      AnimationController(vsync: this, duration: length),
      AnimationController(vsync: this, duration: length),
      AnimationController(vsync: this, duration: length),
    ];

    for (var i = 0; i < animationControllers.length; i++) {
      Future.delayed(
        delay * i,
        () => animationControllers[i].repeat(reverse: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _AnimatedDot(animationController: animationControllers[0]),
        const SizedBox(width: TopDashSpacing.xs),
        _AnimatedDot(animationController: animationControllers[1]),
        const SizedBox(width: TopDashSpacing.xs),
        _AnimatedDot(animationController: animationControllers[2]),
      ],
    );
  }

  @override
  void dispose() {
    for (final controller in animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = Tween<double>(begin: 100, end: 250).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );

    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (BuildContext context, Widget? child) {
        final side = fadeAnimation.value;
        return Container(
          width: TopDashSpacing.lg,
          height: TopDashSpacing.lg,
          decoration: BoxDecoration(
            color: TopDashColors.mainBlue.withAlpha(side.round()),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
