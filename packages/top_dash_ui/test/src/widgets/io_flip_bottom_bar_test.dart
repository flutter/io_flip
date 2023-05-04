// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

void main() {
  group('IoFlipBottomBar', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(IoFlipBottomBar());

      expect(
        find.byType(IoFlipBottomBar),
        findsOneWidget,
      );
    });

    testWidgets('renders size correctly', (tester) async {
      await tester.pumpWidget(IoFlipBottomBar(height: 120));
      expect(
        tester.widget(find.byType(IoFlipBottomBar)),
        isA<IoFlipBottomBar>().having((i) => i.height, 'height', 120),
      );
    });

    testWidgets('renders leading correctly', (tester) async {
      await tester.pumpSubject(
        IoFlipBottomBar(
          leading: Icon(Icons.hiking),
        ),
      );

      expect(
        find.byIcon(Icons.hiking),
        findsOneWidget,
      );
    });

    testWidgets('renders middle correctly', (tester) async {
      await tester.pumpSubject(
        IoFlipBottomBar(
          middle: Icon(Icons.android),
        ),
      );

      expect(
        find.byIcon(Icons.android),
        findsOneWidget,
      );
    });

    testWidgets('renders trailing correctly', (tester) async {
      await tester.pumpSubject(
        IoFlipBottomBar(
          trailing: Icon(Icons.rocket),
        ),
      );

      expect(
        find.byIcon(Icons.rocket),
        findsOneWidget,
      );
    });

    testWidgets('calculates width correctly for narrow space', (tester) async {
      await tester.pumpSubject(
        SizedBox(
          width: 10,
          child: IoFlipBottomBar(
            middle: Icon(Icons.functions),
          ),
        ),
      );

      expect(
        find.byIcon(Icons.functions),
        findsOneWidget,
      );
    });
  });

  group('ToolbarLayout', () {
    testWidgets('shouldRelayout method returns false', (tester) async {
      final delegate = ToolbarLayout();
      final delegate2 = ToolbarLayout();
      await tester.pumpWidget(
        CustomMultiChildLayout(delegate: delegate),
      );

      expect(delegate.shouldRelayout(delegate2), isFalse);
    });
  });
}

extension BottomBarTest on WidgetTester {
  Future<void> pumpSubject(Widget child) async {
    return pumpWidget(
      MaterialApp(
        home: child,
      ),
    );
  }
}
