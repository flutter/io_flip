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
  late final AnimationController dot1;
  late final AnimationController dot2;
  late final AnimationController dot3;

  @override
  void initState() {
    super.initState();
    const length = Duration(milliseconds: 700);
    const delay = Duration(milliseconds: 300);
    dot1 = AnimationController(vsync: this, duration: length);
    dot2 = AnimationController(vsync: this, duration: length);
    dot3 = AnimationController(vsync: this, duration: length);

    dot1.repeat(reverse: true);
    Future.delayed(delay, () => dot2.repeat(reverse: true));
    Future.delayed(delay * 2, () => dot3.repeat(reverse: true));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _AnimatedDot(animationController: dot1),
        const SizedBox(width: TopDashSpacing.xs),
        _AnimatedDot(animationController: dot2),
        const SizedBox(width: TopDashSpacing.xs),
        _AnimatedDot(animationController: dot3),
      ],
    );
  }

  @override
  void dispose() {
    dot1.dispose();
    dot2.dispose();
    dot3.dispose();
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
    final fadeAnimation = Tween<double>(begin: 255, end: 100).animate(
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
