import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LeaderboardView', () {
    Widget buildSubject() => const LeaderboardEntryView();

    testWidgets('renders correct title and subtitle', (tester) async {
      await tester.pumpApp(buildSubject());

      final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

      expect(find.text(l10n.youMadeItToTheLeaderboard), findsOneWidget);
      expect(find.text(l10n.enterYourInitials), findsOneWidget);
    });

    testWidgets('renders initials text field', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('renders continue button', (tester) async {
      await tester.pumpApp(buildSubject());

      final l10n = tester.element(find.byType(LeaderboardEntryView)).l10n;

      expect(find.text(l10n.continueButton.toUpperCase()), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}
