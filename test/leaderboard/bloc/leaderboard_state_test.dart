// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

void main() {
  const card = ScoreCard(id: 'id');
  const leaderboardResult = LeaderboardResults(
    scoreCardsWithLongestStreak: [card],
    scoreCardsWithMostWins: [card],
  );

  group('LeaderboardState', () {
    test('can be instantiated', () {
      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
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
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
          leaderboard: leaderboardResult,
        ),
        equals(
          LeaderboardState(
            status: LeaderboardStateStatus.initial,
            leaderboard: leaderboardResult,
          ),
        ),
      );

      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
        ),
        isNot(
          equals(
            LeaderboardState(
              status: LeaderboardStateStatus.initial,
              leaderboard: leaderboardResult,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the same values', () {
      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
          leaderboard: leaderboardResult,
        ).copyWith(),
        equals(
          LeaderboardState(
            status: LeaderboardStateStatus.initial,
            leaderboard: leaderboardResult,
          ),
        ),
      );
    });

    test('copyWith returns a new instance', () {
      expect(
        LeaderboardState(
          status: LeaderboardStateStatus.initial,
        ).copyWith(
          status: LeaderboardStateStatus.loading,
          leaderboard: leaderboardResult,
        ),
        equals(
          LeaderboardState(
            status: LeaderboardStateStatus.loading,
            leaderboard: leaderboardResult,
          ),
        ),
      );
    });
  });
}
