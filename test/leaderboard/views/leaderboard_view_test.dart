import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardBloc extends MockBloc<LeaderboardEvent, LeaderboardState>
    implements LeaderboardBloc {}

void main() {
  const cardOne = ScoreCard(
    id: 'id1',
    initials: 'AAA',
    wins: 1,
  );
  const cardTwo = ScoreCard(
    id: 'id2',
    initials: 'BBB',
    longestStreak: 2,
  );
  const leaderboardResults = LeaderboardResults(
    scoreCardsWithLongestStreak: [cardOne],
    scoreCardsWithMostWins: [cardTwo],
  );

  group('LeaderboardView', () {
    late LeaderboardBloc leaderboardBloc;

    setUp(() {
      leaderboardBloc = _MockLeaderboardBloc();
      when(() => leaderboardBloc.state).thenReturn(
        const LeaderboardState.initial(),
      );
    });

    testWidgets(
      'renders CircularProgressIndicator when status is initial',
      (tester) async {
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders CircularProgressIndicator when status is loading',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          const LeaderboardState(status: LeaderboardStateStatus.loading),
        );
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders leaderboard failure text when loading fails',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          const LeaderboardState(status: LeaderboardStateStatus.failed),
        );
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

        expect(find.text(tester.l10n.leaderboardFailedToLoad), findsOneWidget);
      },
    );

    testWidgets(
      'renders leaderboard failure text when leaderboard is null',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          const LeaderboardState(status: LeaderboardStateStatus.loaded),
        );
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

        expect(find.text(tester.l10n.leaderboardFailedToLoad), findsOneWidget);
      },
    );

    testWidgets('renders correct tab labels', (tester) async {
      when(() => leaderboardBloc.state).thenReturn(
        const LeaderboardState(
          status: LeaderboardStateStatus.loaded,
          leaderboard: leaderboardResults,
        ),
      );
      await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

      final l10n = tester.l10n;

      expect(find.text(l10n.leaderboardLongestStreak), findsOneWidget);
      expect(find.text(l10n.leaderboardMostWins), findsOneWidget);
    });

    testWidgets('updates index correctly', (tester) async {
      when(() => leaderboardBloc.state).thenReturn(
        const LeaderboardState(
          status: LeaderboardStateStatus.loaded,
          leaderboard: leaderboardResults,
        ),
      );
      await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

      final finder = find.byType(LeaderboardView);

      final index = tester.state<LeaderboardViewState>(finder).index;
      expect(index, 0);

      final l10n = tester.l10n;
      await tester.tap(find.text(l10n.leaderboardMostWins));
      await tester.pumpAndSettle();

      final newIndex = tester.state<LeaderboardViewState>(finder).index;
      expect(newIndex, 1);
    });

    testWidgets(
      'renders LeaderboardPlayers for longest streak',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          const LeaderboardState(
            status: LeaderboardStateStatus.loaded,
            leaderboard: leaderboardResults,
          ),
        );
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

        expect(find.byType(LeaderboardPlayers), findsOneWidget);
        expect(find.text(cardOne.initials!), findsOneWidget);
        expect(find.text(cardOne.longestStreak.toString()), findsOneWidget);
      },
    );

    testWidgets(
      'renders LeaderboardPlayers for most wins',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          const LeaderboardState(
            status: LeaderboardStateStatus.loaded,
            leaderboard: leaderboardResults,
          ),
        );
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

        final l10n = tester.l10n;
        await tester.tap(find.text(l10n.leaderboardMostWins));
        await tester.pumpAndSettle();

        expect(find.byType(LeaderboardPlayers), findsOneWidget);
        expect(find.text(cardTwo.initials!), findsOneWidget);
        expect(find.text(cardTwo.wins.toString()), findsOneWidget);
      },
    );
  });
}

extension DraftViewTest on WidgetTester {
  Future<void> pumpSubject({
    required LeaderboardBloc leaderboardBloc,
  }) async {
    await pumpApp(
      Scaffold(
        body: BlocProvider.value(
          value: leaderboardBloc,
          child: const LeaderboardView(),
        ),
      ),
    );
  }
}
