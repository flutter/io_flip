import 'package:flutter/material.dart';

class FadeAnimatedSwitcher extends StatelessWidget {
  const FadeAnimatedSwitcher({
    required this.duration,
    required this.child,
    super.key,
  });

  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      switchOutCurve: Curves.easeInCubic,
      switchInCurve: Curves.easeInCubic,
      duration: duration,
      child: child,
    );
  }
}
