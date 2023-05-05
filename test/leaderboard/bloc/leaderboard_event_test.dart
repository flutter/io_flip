// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/leaderboard/leaderboard.dart';

void main() {
  group('LeaderboardRequested', () {
    test('can be instantiated', () {
      expect(
        LeaderboardRequested(),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        LeaderboardRequested(),
        equals(
          LeaderboardRequested(),
        ),
      );
    });
  });
}
