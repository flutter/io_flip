import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  const card = ScoreCard(id: 'id');
  const leaderboardResult = LeaderboardResults(
    scoreCardsWithLongestStreak: [card],
    scoreCardsWithMostWins: [card],
  );

  group('LeaderboardBloc', () {
    late LeaderboardResource leaderboardResource;

    setUp(() {
      leaderboardResource = _MockLeaderboardResource();
      when(() => leaderboardResource.getLeaderboardResults())
          .thenAnswer((_) async => leaderboardResult);
    });

    group('LeaderboardRequested', () {
      blocTest<LeaderboardBloc, LeaderboardState>(
        'can request a leaderboard',
        build: () => LeaderboardBloc(
          leaderboardResource: leaderboardResource,
        ),
        act: (bloc) => bloc.add(const LeaderboardRequested()),
        expect: () => const [
          LeaderboardState(
            status: LeaderboardStateStatus.loading,
          ),
          LeaderboardState(
            status: LeaderboardStateStatus.loaded,
            leaderboard: leaderboardResult,
          ),
        ],
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits failure when an error occured',
        setUp: () {
          when(() => leaderboardResource.getLeaderboardResults())
              .thenThrow(Exception('oops'));
        },
        build: () => LeaderboardBloc(
          leaderboardResource: leaderboardResource,
        ),
        act: (bloc) => bloc.add(const LeaderboardRequested()),
        expect: () => const [
          LeaderboardState(
            status: LeaderboardStateStatus.loading,
          ),
          LeaderboardState(
            status: LeaderboardStateStatus.failed,
          ),
        ],
      );
    });
  });
}
