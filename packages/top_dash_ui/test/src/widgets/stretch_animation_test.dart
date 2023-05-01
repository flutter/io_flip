import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('StretchAnimation', () {
    Widget buildSubject({
      required bool animating,
    }) =>
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StretchAnimation(
                animating: animating,
                child: Container(),
              ),
            ),
          ),
        );

    testWidgets('can play animation', (tester) async {
      await tester.pumpWidget(buildSubject(animating: true));
    });

    testWidgets('can stop animation', (tester) async {
      await tester.pumpWidget(buildSubject(animating: true));
      await tester.pumpWidget(buildSubject(animating: false));
    });
  });
}
