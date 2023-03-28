import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class _FakeCustomPainter extends Fake implements CustomPainter {}

void main() {
  group('CardOverlay', () {
    testWidgets(
      'renders check icon and blue background when is win type',
      (tester) async {
        const width = 1200.0;
        const height = 800.0;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: width,
              height: height,
              child: CardOverlay.ofType(CardOverlayType.win, width, height),
            ),
          ),
        );

        expect(
          find.byIcon(Icons.check),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders close icon and red background when is lose type',
      (tester) async {
        const width = 1200.0;
        const height = 800.0;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: width,
              height: height,
              child: CardOverlay.ofType(CardOverlayType.lose, width, height),
            ),
          ),
        );

        expect(
          find.byIcon(Icons.close),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders = and blue background when is draw type',
      (tester) async {
        const width = 1200.0;
        const height = 800.0;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: width,
              height: height,
              child: CardOverlay.ofType(CardOverlayType.draw, width, height),
            ),
          ),
        );

        expect(
          find.text('='),
          findsOneWidget,
        );
      },
    );
  });

  group('OverlayTriangle', () {
    test('shouldRepaint always returns false', () {
      final customPaint = OverlayTriangle(TopDashColors.darkPen);
      expect(customPaint.shouldRepaint(_FakeCustomPainter()), isFalse);
    });
  });
}
