import 'package:flutter/material.dart';
import 'package:top_dash/widgets/game_card.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class CardOverlay extends StatelessWidget {
  factory CardOverlay.ofType(
    CardOverlayType type,
    double? width,
    double? height,
  ) {
    switch (type) {
      case CardOverlayType.draw:
        return CardOverlay._draw(width: width, height: height);
      case CardOverlayType.win:
        return CardOverlay._win(width: width, height: height);
      case CardOverlayType.lose:
        return CardOverlay._lose(width: width, height: height);
    }
  }

  const CardOverlay._win({
    required this.width,
    required this.height,
  })  : color = TopDashColors.seedBlue,
        child = const Icon(
          Icons.check,
          color: Colors.white,
        );

  const CardOverlay._lose({
    required this.width,
    required this.height,
  })  : color = Colors.red,
        child = const Icon(
          Icons.close,
          color: Colors.white,
        );

  const CardOverlay._draw({
    required this.width,
    required this.height,
  })  : color = TopDashColors.drawGrey,
        child = const Text(
          '=',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );

  final Color color;
  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color != TopDashColors.darkPen ? const Color(0x89FFFFFF) : null,
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(40, 40),
            painter: DrawTriangle(color),
          ),
          child,
        ],
      ),
    );
  }
}

class DrawTriangle extends CustomPainter {
  DrawTriangle(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(40, 0)
      ..lineTo(0, 40)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
