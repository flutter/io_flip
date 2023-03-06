import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LeaderboardView', () {
    Widget buildSubject() => const Scaffold(body: LeaderboardView());

    testWidgets('renders correct tab labels', (tester) async {
      await tester.pumpApp(buildSubject());

      final l10n = tester.element(find.byType(LeaderboardView)).l10n;

      expect(find.text(l10n.leaderboardLongestStreak), findsOneWidget);
      expect(find.text(l10n.leaderboardMostWins), findsOneWidget);
    });

    testWidgets('updates index correctly', (tester) async {
      await tester.pumpApp(buildSubject());

      final finder = find.byType(LeaderboardView);

      final index = tester.state<LeaderboardViewState>(finder).index;
      expect(index, 0);

      final l10n = tester.element(finder).l10n;
      await tester.tap(find.text(l10n.leaderboardMostWins));
      await tester.pumpAndSettle();

      final newIndex = tester.state<LeaderboardViewState>(finder).index;
      expect(newIndex, 1);
    });
  });
}
