import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

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
    required this.assetSize,
    required this.cardSize,
    required this.cardOffset,
    super.key,
  }) : controller = DualAnimationController(onComplete);

  /// Represents the widget containing the animation in the back
  final Widget Function(VoidCallback? onComplete, AssetSize assetSize) back;

  /// Represents the widget containing the animation in the front
  final Widget Function(VoidCallback? onComplete, AssetSize assetSize) front;

  /// Controller that check the completion of the animations
  final DualAnimationController controller;

  /// Size of the assets to use, large or small
  final AssetSize assetSize;

  /// Size of the cards
  final GameCardSize cardSize;

  /// Offset of the card within this widget
  final Offset cardOffset;

  @override
  State<DualAnimation> createState() => _DualAnimationState();
}

class _DualAnimationState extends State<DualAnimation> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: ReverseRRectClipper(
            RRect.fromRectAndRadius(
              widget.cardOffset & widget.cardSize.size,
              Radius.circular(widget.cardSize.width * 0.085),
            ),
          ),
          child: widget.back.call(
            widget.controller.backAnimationCompleted,
            widget.assetSize,
          ),
        ),
        widget.front.call(
          widget.controller.frontAnimationCompleted,
          widget.assetSize,
        ),
      ],
    );
  }
}

/// {@template reverse_rrect_clip}
/// Clips to the opposite of the given [RRect].
/// {@endtemplate}
@visibleForTesting
class ReverseRRectClipper extends CustomClipper<Path> {
  /// {@macro reverse_rrect_clip}
  const ReverseRRectClipper(this.roundedRect);

  /// The rounded rect that should be cutout.
  final RRect roundedRect;

  @override
  Path getClip(Size size) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(roundedRect);
  }

  @override
  bool shouldReclip(covariant ReverseRRectClipper oldClipper) {
    return oldClipper.roundedRect != roundedRect;
  }
}
