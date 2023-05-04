import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

void main() {
  group('FadingDotLoader', () {
    testWidgets('renders the animation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: FadingDotLoader(),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 2000));

      expect(find.byType(Container), findsNWidgets(3));
    });
  });
}
