import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template game_card_overlay_type}
/// I/O FLIP Game Card Overlay Type.
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
/// I/O FLIP Card Overlay.
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
        return CardOverlay._draw(
          key: const Key('draw_card_overlay'),
          width: width,
          height: height,
        );
      case CardOverlayType.win:
        return CardOverlay._win(
          key: const Key('win_card_overlay'),
          width: width,
          height: height,
        );
      case CardOverlayType.lose:
        return CardOverlay._lose(
          key: const Key('lose_card_overlay'),
          width: width,
          height: height,
        );
    }
  }

  const CardOverlay._win({
    required this.width,
    required this.height,
    super.key,
  })  : color = TopDashColors.seedBlue,
        isDimmed = false,
        child = const Icon(
          Icons.check,
          color: TopDashColors.seedWhite,
        );

  const CardOverlay._lose({
    required this.width,
    required this.height,
    super.key,
  })  : color = TopDashColors.seedRed,
        isDimmed = true,
        child = const Icon(
          Icons.close,
          color: TopDashColors.seedWhite,
        );

  const CardOverlay._draw({
    required this.width,
    required this.height,
    super.key,
  })  : color = TopDashColors.seedGrey50,
        isDimmed = true,
        child = const Text(
          '=',
          style: TextStyle(color: TopDashColors.seedWhite, fontSize: 24),
        );

  /// Color
  final Color color;

  /// Child widget
  final Widget child;

  /// Width
  final double? width;

  /// Height
  final double? height;

  /// Whether the card has a dimming effect
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDimmed ? TopDashColors.seedWhite.withOpacity(.5) : null,
          border: Border.all(width: 2, color: color),
          borderRadius: borderRadius,
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
      ),
    );
  }
}

/// {@template card_overlay_triangle}
/// I/O FLIP Card Overlay Triangle.
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
