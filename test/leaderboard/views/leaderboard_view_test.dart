import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as gd;
import 'package:io_flip/leaderboard/leaderboard.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockLeaderboardBloc extends MockBloc<LeaderboardEvent, LeaderboardState>
    implements LeaderboardBloc {}

void main() {
  const playerOne = gd.LeaderboardPlayer(
    id: 'id',
    longestStreak: 1,
    initials: 'AAA',
  );
  const playerTwo = gd.LeaderboardPlayer(
    id: 'id2',
    longestStreak: 2,
    initials: 'BBB',
  );
  const leaderboardPlayers = [playerOne, playerTwo];

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
          const LeaderboardState(
            status: LeaderboardStateStatus.loading,
            leaderboard: [],
          ),
        );
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders leaderboard failure text when loading fails',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          const LeaderboardState(
            status: LeaderboardStateStatus.failed,
            leaderboard: [],
          ),
        );
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

        expect(find.text(tester.l10n.leaderboardFailedToLoad), findsOneWidget);
      },
    );

    testWidgets('renders correct label', (tester) async {
      when(() => leaderboardBloc.state).thenReturn(
        const LeaderboardState(
          status: LeaderboardStateStatus.loaded,
          leaderboard: leaderboardPlayers,
        ),
      );
      await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

      final l10n = tester.l10n;

      expect(find.text(l10n.leaderboardLongestStreak), findsOneWidget);
    });

    testWidgets(
      'renders LeaderboardPlayers for longest streak',
      (tester) async {
        when(() => leaderboardBloc.state).thenReturn(
          const LeaderboardState(
            status: LeaderboardStateStatus.loaded,
            leaderboard: leaderboardPlayers,
          ),
        );
        await tester.pumpSubject(leaderboardBloc: leaderboardBloc);

        expect(find.byType(LeaderboardPlayers), findsOneWidget);
        expect(find.text(playerOne.initials), findsOneWidget);
        expect(find.text(playerOne.longestStreak.toString()), findsOneWidget);
        expect(find.text(playerTwo.initials), findsOneWidget);
        expect(find.text(playerTwo.longestStreak.toString()), findsOneWidget);
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
