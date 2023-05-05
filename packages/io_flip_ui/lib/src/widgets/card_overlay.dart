import 'package:flutter/material.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';
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
    CardOverlayType type, {
    required BorderRadius borderRadius,
    required bool isDimmed,
  }) {
    switch (type) {
      case CardOverlayType.draw:
        return CardOverlay._draw(
          key: const Key('draw_card_overlay'),
          borderRadius: borderRadius,
          isDimmed: isDimmed,
        );
      case CardOverlayType.win:
        return CardOverlay._win(
          key: const Key('win_card_overlay'),
          borderRadius: borderRadius,
          isDimmed: isDimmed,
        );
      case CardOverlayType.lose:
        return CardOverlay._lose(
          key: const Key('lose_card_overlay'),
          borderRadius: borderRadius,
          isDimmed: isDimmed,
        );
    }
  }

  CardOverlay._win({
    required this.borderRadius,
    required this.isDimmed,
    super.key,
  })  : color = IoFlipColors.seedGreen,
        asset = Assets.images.resultBadges.win.path;

  CardOverlay._lose({
    required this.borderRadius,
    required this.isDimmed,
    super.key,
  })  : color = IoFlipColors.seedRed,
        asset = Assets.images.resultBadges.lose.path;

  CardOverlay._draw({
    required this.borderRadius,
    required this.isDimmed,
    super.key,
  })  : color = IoFlipColors.seedPaletteNeutral90,
        asset = Assets.images.resultBadges.draw.path;

  /// Color
  final Color color;

  /// Result badge asset
  final String asset;

  /// Border radius
  final BorderRadius borderRadius;

  /// Whether the card has a dimming effect
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDimmed ? IoFlipColors.seedBlack.withOpacity(.4) : null,
          border: Border.all(width: 4, color: color),
          borderRadius: borderRadius,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 3,
              left: 3,
              child: CustomPaint(
                size: const Size(40, 40),
                painter: OverlayTriangle(color),
              ),
            ),
            Positioned(
              top: 3,
              left: 3,
              child: Image.asset(
                asset,
                package: 'io_flip_ui',
                height: 40,
                width: 40,
              ),
            ),
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
