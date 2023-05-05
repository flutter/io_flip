// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

void main() {
  group('IoFlipErrorView', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject();

      expect(
        find.byType(IoFlipErrorView),
        findsOneWidget,
      );
      expect(find.text('Hey'), findsOneWidget);
      expect(find.text('Play again'), findsOneWidget);
    });

    testWidgets('button tap works correctly', (tester) async {
      var flag = false;
      await tester.pumpSubject(
        onPressed: () {
          flag = true;
        },
      );

      await tester.tap(find.byType(RoundedButton));
      await tester.pumpAndSettle();

      expect(flag, equals(true));
    });
  });
}

extension IoFlipErrorViewTest on WidgetTester {
  Future<void> pumpSubject({
    void Function()? onPressed,
  }) {
    return pumpWidget(
      MaterialApp(
        home: Provider(
          create: (_) => UISoundAdapter(playButtonSound: () {}),
          child: Scaffold(
            body: IoFlipErrorView(
              text: 'Hey',
              buttonText: 'Play again',
              onPressed: onPressed ?? () {},
            ),
          ),
        ),
      ),
    );
  }
}
