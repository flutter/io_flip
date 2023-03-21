import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LeaderboardEntryView', () {
    testWidgets('renders correct title and subtitle', (tester) async {
      await tester.pumpSubject();

      final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

      expect(find.text(l10n.youMadeItToTheLeaderboard), findsOneWidget);
      expect(find.text(l10n.enterYourInitials), findsOneWidget);
    });

    testWidgets('renders continue button', (tester) async {
      await tester.pumpSubject();

      final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

      expect(find.text(l10n.continueButton.toUpperCase()), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    group('initials textfield', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpSubject();

        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('validates initials', (tester) async {
        await tester.pumpSubject();

        final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

        await tester.enterText(find.byType(TextField), 'AAA');
        await tester.tap(find.byType(OutlinedButton));
        await tester.pumpAndSettle();

        expect(find.text(l10n.enterInitialsError), findsNothing);
      });

      testWidgets('shows error text on failed validation', (tester) async {
        await tester.pumpSubject();

        final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

        await tester.enterText(find.byType(TextField), 'AA');
        await tester.tap(find.byType(OutlinedButton));
        await tester.pumpAndSettle();

        expect(find.text(l10n.enterInitialsError), findsOneWidget);
      });

      testWidgets(
        'shows error text on failed validation due to blacklisted initials',
        (tester) async {
          await tester.pumpSubject();

          final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

          await tester.enterText(find.byType(TextField), 'WTF');
          await tester.tap(find.byType(OutlinedButton));
          await tester.pumpAndSettle();

          expect(find.text(l10n.enterInitialsError), findsOneWidget);
        },
      );

      testWidgets('capitalizes lowercase letters', (tester) async {
        await tester.pumpSubject();

        final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

        await tester.enterText(find.byType(TextField), 'aaa');
        await tester.tap(find.byType(OutlinedButton));
        await tester.pumpAndSettle();
        final input = tester.widget<EditableText>(find.byType(EditableText));
        expect(input.controller.text == 'AAA', isTrue);

        expect(find.text(l10n.enterInitialsError), findsNothing);
      });
    });
  });
}

extension LeaderboardEntryViewTest on WidgetTester {
  Future<void> pumpSubject() async {
    return pumpApp(
      const LeaderboardEntryView(),
    );
  }
}
