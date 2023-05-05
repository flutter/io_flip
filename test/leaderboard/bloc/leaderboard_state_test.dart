// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as gd;
import 'package:io_flip/leaderboard/leaderboard.dart';

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

  group('LeaderboardState', () {
    test('can be instantiated', () {
      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
          leaderboard: const [],
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        LeaderboardState.initial(),
        equals(
          LeaderboardState(
            status: LeaderboardStateStatus.initial,
            leaderboard: const [],
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
          leaderboard: leaderboardPlayers,
        ),
        equals(
          LeaderboardState(
            status: LeaderboardStateStatus.initial,
            leaderboard: leaderboardPlayers,
          ),
        ),
      );

      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
          leaderboard: const [],
        ),
        isNot(
          equals(
            LeaderboardState(
              status: LeaderboardStateStatus.initial,
              leaderboard: leaderboardPlayers,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the same values', () {
      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
          leaderboard: leaderboardPlayers,
        ).copyWith(),
        equals(
          LeaderboardState(
            status: LeaderboardStateStatus.initial,
            leaderboard: leaderboardPlayers,
          ),
        ),
      );
    });

    test('copyWith returns a new instance', () {
      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
          leaderboard: const [],
        ).copyWith(
          status: LeaderboardStateStatus.loading,
          leaderboard: leaderboardPlayers,
        ),
        equals(
          LeaderboardState(
            status: LeaderboardStateStatus.loading,
            leaderboard: leaderboardPlayers,
          ),
        ),
      );
    });
  });
}
