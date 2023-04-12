import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

const Duration transitionDuration = Duration(milliseconds: 500);

class ArrowWidget extends StatelessWidget {
  const ArrowWidget(
    this.p1,
    this.p2, {
    this.visible = true,
    super.key,
  });

  final Offset p1;
  final Offset p2;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: transitionDuration,
      child: CustomPaint(painter: ArrowPainter(p1, p2)),
    );
  }
}

class ArrowPainter extends CustomPainter {
  const ArrowPainter(this.p1, this.p2);

  final Offset p1;
  final Offset p2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TopDashColors.seedGrey30
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final dX = p2.dx - p1.dx;
    final dY = p2.dy - p1.dy;
    final angle = math.atan2(dY, dX);

    const arrowSize = 16;
    const arrowAngle = 45 * math.pi / 180;

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(
        p2.dx - arrowSize * math.cos(angle - arrowAngle),
        p2.dy - arrowSize * math.sin(angle - arrowAngle),
      )
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(
        p2.dx - arrowSize * math.cos(angle + arrowAngle),
        p2.dy - arrowSize * math.sin(angle + arrowAngle),
      )
      ..lineTo(p2.dx, p2.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
