import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('FlipCountdown', () {
    testWidgets('renders SpriteAnimationWidget', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: FlipCountdown(),
        ),
      );

      expect(find.byType(SpriteAnimationWidget), findsOneWidget);
    });
  });
}
