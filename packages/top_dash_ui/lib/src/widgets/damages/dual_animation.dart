import 'package:flutter/material.dart';

/// {@template elemental_damage_animation}
/// A widget that renders two [SpriteAnimation] one over the other
/// {@endtemplate}
class DualAnimation extends StatefulWidget {
  /// {@macro elemental_damage_animation}
  const DualAnimation({
    required this.animationA,
    required this.animationB,
    required this.onComplete,
    super.key,
  });

  /// Optional callback to be called when all the animations are complete.
  final VoidCallback onComplete;

  ///
  final Widget Function(VoidCallback? onComplete) animationA;

  ///
  final Widget Function(VoidCallback? onComplete) animationB;

  @override
  State<DualAnimation> createState() => _DualAnimationState();
}

class _DualAnimationState extends State<DualAnimation> {
  bool animationACompleted = false;
  bool animationBCompleted = false;

  void _checkCompletion() {
    if (animationACompleted && animationBCompleted) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.animationA.call(
          () => setState(() {
            animationACompleted = true;
            _checkCompletion();
          }),
        ),
        widget.animationB.call(
          () => setState(() {
            animationBCompleted = true;
            _checkCompletion();
          }),
        ),
      ],
    );
  }
}
