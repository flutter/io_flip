import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/src/widgets/top_dash_dialog.dart';

void main() {
  group('TopDashDialog', () {
    const child = Text('test');

    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TopDashDialog(child: child),
          ),
        ),
      );

      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('calls onClose method', (tester) async {
      var onCloseCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TopDashDialog(
              onClose: () => onCloseCalled = true,
              child: child,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();

      expect(onCloseCalled, isTrue);
    });

    group('show', () {
      testWidgets('renders the dialog with correct child', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (BuildContext context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => TopDashDialog.show(
                      context,
                      child: child,
                    ),
                    child: const Text('show'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byWidget(child), findsOneWidget);
      });
    });
  });
}
