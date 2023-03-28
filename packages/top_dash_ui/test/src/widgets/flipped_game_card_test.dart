import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('FlippedGameCard', () {
    testWidgets(
      'renders correctly',
      (tester) async {
        await tester.pumpWidget(const FlippedGameCard());

        expect(
          find.byType(Container),
          findsOneWidget,
        );
      },
    );
  });
}
