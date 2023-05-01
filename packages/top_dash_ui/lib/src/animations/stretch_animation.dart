import 'package:flutter/widgets.dart';

/// {@template stretch_animation}
/// Applies an elastic scale transition to [child].
/// {@endtemplate}
class StretchAnimation extends StatefulWidget {
  /// {@macro stretch_animation}
  const StretchAnimation({
    required this.child,
    this.animating = false,
    super.key,
  });

  /// The [child] of [StretchAnimation] to become animated.
  final Widget child;

  /// Whether or not the animation is enabled.
  final bool animating;

  @override
  State<StretchAnimation> createState() => _StretchAnimationState();
}

class _StretchAnimationState extends State<StretchAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
    lowerBound: 0.35,
  );
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

  @override
  void initState() {
    if (widget.animating) {
      _controller.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StretchAnimation oldWidget) {
    if (oldWidget.animating != widget.animating) {
      if (widget.animating) {
        _controller
          ..reset()
          ..forward();
      } else {
        _controller.stop();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
