import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class _FakeCustomPainter extends Fake implements CustomPainter {}

void main() {
  group('CardOverlay', () {
    testWidgets(
      'renders win asset and green background when is win type',
      (tester) async {
        const width = 1200.0;
        const height = 800.0;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: width,
              height: height,
              child: CardOverlay.ofType(
                CardOverlayType.win,
                borderRadius: BorderRadius.circular(4),
                isDimmed: false,
              ),
            ),
          ),
        );

        expect(
          tester.widget(find.byType(CardOverlay)),
          isA<CardOverlay>()
              .having(
                (o) => o.asset,
                'asset',
                equals(Assets.images.resultBadges.win.path),
              )
              .having(
                (o) => o.color,
                'color',
                equals(IoFlipColors.seedGreen),
              ),
        );
      },
    );

    testWidgets(
      'renders lose asset and red background when is lose type',
      (tester) async {
        const width = 1200.0;
        const height = 800.0;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: width,
              height: height,
              child: CardOverlay.ofType(
                CardOverlayType.lose,
                borderRadius: BorderRadius.circular(4),
                isDimmed: false,
              ),
            ),
          ),
        );

        expect(
          tester.widget(find.byType(CardOverlay)),
          isA<CardOverlay>()
              .having(
                (o) => o.asset,
                'asset',
                equals(Assets.images.resultBadges.lose.path),
              )
              .having(
                (o) => o.color,
                'color',
                equals(IoFlipColors.seedRed),
              ),
        );
      },
    );

    testWidgets(
      'renders draw asset and neutral background when is draw type',
      (tester) async {
        const width = 1200.0;
        const height = 800.0;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: width,
              height: height,
              child: CardOverlay.ofType(
                CardOverlayType.draw,
                borderRadius: BorderRadius.circular(4),
                isDimmed: false,
              ),
            ),
          ),
        );

        expect(
          tester.widget(find.byType(CardOverlay)),
          isA<CardOverlay>()
              .having(
                (o) => o.asset,
                'asset',
                equals(Assets.images.resultBadges.draw.path),
              )
              .having(
                (o) => o.color,
                'color',
                equals(IoFlipColors.seedPaletteNeutral90),
              ),
        );
      },
    );
  });

  group('OverlayTriangle', () {
    test('shouldRepaint always returns false', () {
      final customPaint = OverlayTriangle(IoFlipColors.seedBlue);
      expect(customPaint.shouldRepaint(_FakeCustomPainter()), isFalse);
    });
  });
}
