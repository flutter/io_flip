// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  group('IoFlipScaffold', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: IoFlipScaffold(
            body: Center(child: Text('Test')),
          ),
        ),
      );

      expect(
        find.byType(IoFlipScaffold),
        findsOneWidget,
      );
    });
  });
}
