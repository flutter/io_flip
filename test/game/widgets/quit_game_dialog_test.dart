import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('QuitGameDialog', () {
    Widget buildSubject({
      VoidCallback? onConfirm,
      VoidCallback? onCancel,
    }) =>
        QuitGameDialog(
          onConfirm: onConfirm ?? () {},
          onCancel: onCancel ?? () {},
        );

    testWidgets('renders a Dialog with correct text', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text(tester.l10n.quitGameDialogTitle), findsOneWidget);
      expect(find.text(tester.l10n.quitGameDialogDescription), findsOneWidget);
    });

    testWidgets(
      'calls onConfirm when the quit button is tapped',
      (tester) async {
        var onConfirmCalled = false;

        await tester.pumpApp(
          buildSubject(
            onConfirm: () => onConfirmCalled = true,
          ),
        );

        await tester.tap(find.text(tester.l10n.quit));

        expect(onConfirmCalled, isTrue);
      },
    );

    testWidgets(
      'calls onCancel when the cancel button is tapped',
      (tester) async {
        var onCancelCalled = false;

        await tester.pumpApp(
          buildSubject(
            onCancel: () => onCancelCalled = true,
          ),
        );

        await tester.tap(find.text(tester.l10n.cancel));

        expect(onCancelCalled, isTrue);
      },
    );

    testWidgets(
      'calls onCancel when the close icon button is tapped',
      (tester) async {
        var onCancelCalled = false;

        await tester.pumpApp(
          buildSubject(
            onCancel: () => onCancelCalled = true,
          ),
        );

        await tester.tap(find.byIcon(Icons.close));

        expect(onCancelCalled, isTrue);
      },
    );

    group('show', () {
      testWidgets('shows the QuitGameDialog', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => QuitGameDialog.show(
                  context,
                  onCancel: () {},
                  onConfirm: () {},
                ),
                child: const Text('show'),
              );
            },
          ),
        );

        expect(find.byType(QuitGameDialog), findsNothing);

        await tester.tap(find.text('show'));
        await tester.pumpAndSettle();

        expect(find.byType(QuitGameDialog), findsOneWidget);
      });
    });
  });
}
