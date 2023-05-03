import 'package:flutter/material.dart';

/// {@template dual_animation_controller}
/// Controls the completion state of the front and back animations in a
/// [DualAnimation] widget.
///
/// Listens to the completion of front and back animations and triggers the
/// [onComplete] callback when both animations are finished.
/// {@endtemplate}
class DualAnimationController {
  /// {@macro dual_animation_controller}
  DualAnimationController(this.onComplete);

  /// Called when both animations are completed
  final VoidCallback? onComplete;

  bool _frontAnimationCompleted = false;

  bool _backAnimationCompleted = false;

  void _checkCompletion() {
    if (_frontAnimationCompleted && _backAnimationCompleted) {
      onComplete?.call();
      // Reset the completion status to avoid calling onComplete multiple times.
      _frontAnimationCompleted = false;
      _backAnimationCompleted = false;
    }
  }

  /// Marks the front animation as completed and checks
  /// if both animations are finished.
  ///
  /// If both animations are finished, the [onComplete] callback will be called.
  void frontAnimationCompleted() {
    _frontAnimationCompleted = true;
    _checkCompletion();
  }

  /// Marks the back animation as completed and checks
  /// if both animations are finished.
  ///
  /// If both animations are finished, the [onComplete] callback will be called
  void backAnimationCompleted() {
    _backAnimationCompleted = true;
    _checkCompletion();
  }
}

/// {@template elemental_damage_animation}
// ignore: comment_references
/// A widget that renders two [SpriteAnimation] one over the other
/// {@endtemplate}
class DualAnimation extends StatefulWidget {
  /// {@macro elemental_damage_animation}
  DualAnimation({
    required this.back,
    required this.front,
    required VoidCallback onComplete,
    super.key,
  }) : controller = DualAnimationController(onComplete);

  /// Represents the widget containing the animation in the back
  final Widget Function(VoidCallback? onComplete) back;

  /// Represents the widget containing the animation in the front
  final Widget Function(VoidCallback? onComplete) front;

  /// Controller that check the completion of the animations
  final DualAnimationController controller;

  @override
  State<DualAnimation> createState() => _DualAnimationState();
}

class _DualAnimationState extends State<DualAnimation> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.back.call(widget.controller.backAnimationCompleted),
        widget.front.call(widget.controller.frontAnimationCompleted),
      ],
    );
  }
}
