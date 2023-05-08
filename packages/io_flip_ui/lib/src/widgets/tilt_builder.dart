import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Builds the widget for a [TiltBuilder]
typedef OffsetWidgetBuilder = Widget Function(
  BuildContext context,
  Offset offset,
);

/// {@template tilt_builder}
/// Used to build another widget, passing down the pointer position
/// as an [Offset] with dx and dy between -1 and 1. It also animates the
/// offset back to [Offset.zero] when the pointer leaves.
/// {@endtemplate}
class TiltBuilder extends StatefulWidget {
  /// {@macro tilt_builder}
  const TiltBuilder({required this.builder, super.key});

  /// Builds a child widget with an offset determined by the pointer position.
  final OffsetWidgetBuilder builder;

  @override
  State<TiltBuilder> createState() => _TiltBuilderState();
}

class _TiltBuilderState extends State<TiltBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final _tiltTween = Tween<Offset>(end: Offset.zero);
  Offset tilt = Offset.zero;
  bool entered = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void reset(_) {
    _tiltTween
      ..begin = tilt
      ..end = Offset.zero;
    _animationController
      ..addListener(onAnimationUpdate)
      ..forward(from: 0);
  }

  void startTilt(Offset mousePosition) {
    final newTilt = getTilt(mousePosition);
    if (newTilt != null) {
      _tiltTween
        ..begin = tilt
        ..end = newTilt;
      _animationController
        ..addListener(onAnimationUpdate)
        ..forward(from: 0).whenCompleteOrCancel(() {
          entered = true;
        });
    }
  }

  void onUpdate(Offset pointerPosition) {
    if (entered) {
      final newTilt = getTilt(pointerPosition);

      if (newTilt != null) {
        setState(() {
          tilt = newTilt;
        });
      }
    }
  }

  void onAnimationUpdate() {
    setState(() {
      tilt = _tiltTween
          .chain(CurveTween(curve: Curves.easeOutQuad))
          .evaluate(_animationController);
    });
  }

  Offset? getTilt(Offset mousePosition) {
    final size = context.size;

    if (size != null) {
      final dx = (mousePosition.dx / size.width) * 2 - 1;
      final dy = (mousePosition.dy / size.height) * 2 - 1;
      return Offset(dx, dy);
    }
    return null;
  }

  @override
  void dispose() {
    _animationController
      ..removeListener(onAnimationUpdate)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        if (details.kind == PointerDeviceKind.touch) {
          startTilt(details.localPosition);
        }
      },
      onPanUpdate: (details) => onUpdate(details.localPosition),
      onPanEnd: reset,
      child: MouseRegion(
        onExit: reset,
        onEnter: (event) => startTilt(event.localPosition),
        onHover: (event) => onUpdate(event.localPosition),
        child: widget.builder(context, tilt),
      ),
    );
  }
}
