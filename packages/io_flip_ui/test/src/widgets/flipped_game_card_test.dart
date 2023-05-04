import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  group('FlippedGameCard', () {
    testWidgets(
      'renders correctly',
      (tester) async {
        await tester.pumpWidget(const FlippedGameCard());

        expect(
          find.byType(Image),
          findsOneWidget,
        );
      },
    );
  });
}
