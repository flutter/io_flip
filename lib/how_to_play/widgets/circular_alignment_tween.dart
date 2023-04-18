import 'package:flutter/material.dart';

class CircularAlignmentTween extends AlignmentTween {
  CircularAlignmentTween({super.begin, super.end});

  @override
  Alignment lerp(double t) {
    final t1 = 1 - t;

    final beginOffset = Offset(begin!.x, begin!.y);
    final endOffset = Offset(end!.x, end!.y);
    final control = (beginOffset + endOffset) * .75;
    final result =
        beginOffset * t1 * t1 + control * 2 * t1 * t + endOffset * t * t;
    return Alignment(result.dx, result.dy);
  }
}
