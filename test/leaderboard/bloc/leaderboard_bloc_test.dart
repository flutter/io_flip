import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as gd;
import 'package:io_flip/leaderboard/leaderboard.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  const leaderboardPlayers = [
    gd.LeaderboardPlayer(
      id: 'id',
      longestStreak: 1,
      initials: 'AAA',
    ),
    gd.LeaderboardPlayer(
      id: 'id2',
      longestStreak: 2,
      initials: 'BBB',
    ),
  ];

  group('LeaderboardBloc', () {
    late LeaderboardResource leaderboardResource;

    setUp(() {
      leaderboardResource = _MockLeaderboardResource();
      when(() => leaderboardResource.getLeaderboardResults())
          .thenAnswer((_) async => leaderboardPlayers);
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
            leaderboard: [],
          ),
          LeaderboardState(
            status: LeaderboardStateStatus.loaded,
            leaderboard: leaderboardPlayers,
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
            leaderboard: [],
          ),
          LeaderboardState(
            status: LeaderboardStateStatus.failed,
            leaderboard: [],
          ),
        ],
      );
    });
  });
}
