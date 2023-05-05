// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardPlayer', () {
    test('can be instantiated', () {
      expect(
        LeaderboardPlayer(
          id: 'id',
          longestStreak: 1,
          initials: 'TST',
        ),
        isNotNull,
      );
    });

    final leaderboardPlayer = LeaderboardPlayer(
      id: 'id',
      longestStreak: 1,
      initials: 'TST',
    );

    test('toJson returns the instance as json', () {
      expect(
        leaderboardPlayer.toJson(),
        equals({
          'id': 'id',
          'longestStreak': 1,
          'initials': 'TST',
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        LeaderboardPlayer.fromJson(const {
          'id': 'id',
          'longestStreak': 1,
          'initials': 'TST',
        }),
        equals(leaderboardPlayer),
      );
    });

    test('supports equality', () {
      expect(
        LeaderboardPlayer(id: '', longestStreak: 1, initials: 'TST'),
        equals(LeaderboardPlayer(id: '', longestStreak: 1, initials: 'TST')),
      );

      expect(
        LeaderboardPlayer(
          id: '',
          longestStreak: 1,
          initials: 'TST',
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );
      expect(
        LeaderboardPlayer(
          id: 'id',
          longestStreak: 2,
          initials: 'TST',
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );
      expect(
        LeaderboardPlayer(
          id: 'id',
          longestStreak: 1,
          initials: 'WOW',
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );
    });
  });
}
