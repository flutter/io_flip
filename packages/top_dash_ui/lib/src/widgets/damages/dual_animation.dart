import 'package:flutter/material.dart';

/// {@template elemental_damage_animation}
// ignore: comment_references
/// A widget that renders two [SpriteAnimation] one over the other
/// {@endtemplate}
class DualAnimation extends StatefulWidget {
  /// {@macro elemental_damage_animation}
  const DualAnimation({
    required this.back,
    required this.front,
    required this.onComplete,
    super.key,
  });

  /// Optional callback to be called when all the animations are complete.
  final VoidCallback onComplete;

  /// Represents the widget containing the animation in the back
  final Widget Function(VoidCallback? onComplete) back;

  /// Represents the widget containing the animation in the front
  final Widget Function(VoidCallback? onComplete) front;

  @override
  State<DualAnimation> createState() => _DualAnimationState();
}

class _DualAnimationState extends State<DualAnimation> {
  bool frontAnimationCompleted = false;
  bool backAnimationCompleted = false;

  void _checkCompletion() {
    if (frontAnimationCompleted && backAnimationCompleted) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.back.call(
          () => setState(() {
            frontAnimationCompleted = true;
            _checkCompletion();
          }),
        ),
        widget.front.call(
          () => setState(() {
            backAnimationCompleted = true;
            _checkCompletion();
          }),
        ),
      ],
    );
  }
}
