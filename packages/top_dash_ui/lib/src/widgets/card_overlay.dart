import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template game_card_overlay_type}
/// Top Dash Game Card Overlay Type.
/// {@endtemplate}
enum CardOverlayType {
  /// Win
  win,

  /// Lose
  lose,

  /// Draw
  draw,
}

/// {@template card_overlay}
/// Top Dash Card Overlay.
/// {@endtemplate}
class CardOverlay extends StatelessWidget {
  /// {@macro card_overlay}
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
          color: TopDashColors.white,
        );

  const CardOverlay._lose({
    required this.width,
    required this.height,
  })  : color = TopDashColors.seedRed,
        child = const Icon(
          Icons.close,
          color: TopDashColors.white,
        );

  const CardOverlay._draw({
    required this.width,
    required this.height,
  })  : color = TopDashColors.drawGrey,
        child = const Text(
          '=',
          style: TextStyle(color: TopDashColors.white, fontSize: 24),
        );

  /// Color
  final Color color;

  /// Child widget
  final Widget child;

  /// Width
  final double? width;

  /// Height
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color != TopDashColors.darkPen
            ? TopDashColors.transparentWhite
            : null,
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(40, 40),
            painter: OverlayTriangle(color),
          ),
          child,
        ],
      ),
    );
  }
}

/// {@template card_overlay_triangle}
/// Top Dash Card Overlay Triangle.
/// {@endtemplate}
@visibleForTesting
class OverlayTriangle extends CustomPainter {
  /// {@macro card_overlay_triangle}
  OverlayTriangle(this.color);

  /// Color
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
