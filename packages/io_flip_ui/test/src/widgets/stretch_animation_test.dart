import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  group('StretchAnimation', () {
    late bool complete;

    setUp(() {
      complete = false;
    });

    Widget buildSubject({
      required bool animating,
    }) =>
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StretchAnimation(
                animating: animating,
                onComplete: () {
                  complete = true;
                },
                child: Container(),
              ),
            ),
          ),
        );

    testWidgets('can play animation', (tester) async {
      await tester.pumpWidget(buildSubject(animating: true));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('can stop animation', (tester) async {
      await tester.pumpWidget(buildSubject(animating: true));
      await tester.pumpWidget(buildSubject(animating: false));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);
    });
    testWidgets('can start animation', (tester) async {
      await tester.pumpWidget(buildSubject(animating: false));
      await tester.pumpWidget(buildSubject(animating: true));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('calls onComplete after it finishes', (tester) async {
      await tester.pumpWidget(buildSubject(animating: true));
      await tester.pumpAndSettle();
      expect(complete, isTrue);
    });
  });
}
