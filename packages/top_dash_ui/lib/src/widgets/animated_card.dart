import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

/// A controller used to run animations on an [AnimatedCard].
class AnimatedCardController {
  _AnimatedCardState? _state;

  /// Runs the given [animation] on the [AnimatedCard] associated with this
  /// controller.
  TickerFuture run(CardAnimation animation) {
    _state?._animatable = animation.animatable;
    _state?._controller.value = 0;

    if (_state == null) {
      return TickerFuture.complete();
    } else {
      return _state!._controller.animateTo(
        1,
        curve: animation.curve,
        duration: animation.duration,
      )..whenCompleteOrCancel(() {
          _state?._controller.value = 0;
          if (animation.flipsCard) {
            _state?._flip();
          }
        });
    }
  }

  /// Disposes of resources used by this controller.
  void dispose() {
    _state = null;
  }
}

/// {@template animated_card}
/// A widget that animates according to the given [controller], and can flip
/// between two sides.
/// {@endtemplate}
class AnimatedCard extends StatefulWidget {
  /// {@macro animated_card}
  const AnimatedCard({
    required this.front,
    required this.back,
    required this.controller,
    super.key,
  });

  /// The widget to show on the front side of the card.
  ///
  /// This widget will be shown when the card is not flipped.
  final Widget front;

  /// The widget to show on the back side of the card.
  ///
  /// This widget will be shown when the card is flipped.
  final Widget back;

  /// The controller used to run animations on this card.
  final AnimatedCardController controller;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animatable<Matrix4> _animatable = TransformTween();
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
    widget.controller._state = this;
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  void _flip() {
    setState(() {
      _flipped = !_flipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FlipTransform(
          transform: _animatable.evaluate(_controller),
          front: _flipped ? widget.back : widget.front,
          back: _flipped ? widget.front : widget.back,
        );
      },
    );
  }
}

/// {@template flip_transform}
/// A widget that is used like [Transform], but shows a different child when the
/// rotation around the y-axis is greater than 90 degrees.
/// {@endtemplate}
class FlipTransform extends StatelessWidget {
  /// {@macro flip_transform}
  const FlipTransform({
    required this.transform,
    required this.front,
    required this.back,
    super.key,
  });

  /// The transform to apply to the child.
  final Matrix4 transform;

  /// The widget to show when the rotation around the y-axis is
  /// less than or equal to 90 degrees.
  final Widget front;

  /// The widget to show when the rotation around the y-axis is
  /// greater than 90 degrees.
  final Widget back;

  double get _rotationY => math.acos(transform.getRotation().entry(0, 0));

  bool get _isFlipping => _rotationY > math.pi / 2 && _rotationY <= math.pi;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform:
          _isFlipping ? (Matrix4.copy(transform)..rotateY(math.pi)) : transform,
      alignment: Alignment.center,
      child: _isFlipping ? back : front,
    );
  }
}
