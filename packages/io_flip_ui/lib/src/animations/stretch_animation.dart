import 'package:flutter/widgets.dart';

/// {@template stretch_animation}
/// Applies an elastic scale transition to [child].
/// {@endtemplate}
class StretchAnimation extends StatefulWidget {
  /// {@macro stretch_animation}
  const StretchAnimation({
    required this.child,
    this.animating = false,
    this.onComplete,
    super.key,
  });

  /// The [child] of [StretchAnimation] to become animated.
  final Widget child;

  /// Whether or not the animation is enabled.
  final bool animating;

  /// Called when the animation finishes.
  final VoidCallback? onComplete;

  @override
  State<StretchAnimation> createState() => _StretchAnimationState();
}

class _StretchAnimationState extends State<StretchAnimation>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
    lowerBound: 0.35,
  );
  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
    if (widget.animating) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StretchAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animating != widget.animating) {
      if (widget.animating) {
        _controller
          ..reset()
          ..forward();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
