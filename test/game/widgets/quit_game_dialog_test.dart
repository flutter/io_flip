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

    testWidgets('renders correct texts', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text(tester.l10n.quitGameDialogTitle), findsOneWidget);
      expect(find.text(tester.l10n.quitGameDialogDescription), findsOneWidget);
    });

    testWidgets(
      'calls onConfirm when the continue button is tapped',
      (tester) async {
        var onConfirmCalled = false;

        await tester.pumpApp(
          buildSubject(
            onConfirm: () => onConfirmCalled = true,
          ),
        );

        await tester.tap(find.text(tester.l10n.continueLabel));

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
  });
}
