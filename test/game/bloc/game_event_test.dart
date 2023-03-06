// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/game/game.dart';

void main() {
  group('GameEvent', () {
    group('MatchRequested', () {
      test('can be instantiated', () {
        expect(MatchRequested('match1'), isNotNull);
      });

      test('supports equality', () {
        expect(
          MatchRequested('match1'),
          equals(MatchRequested('match1')),
        );

        expect(
          MatchRequested('match1'),
          isNot(equals(MatchRequested('match2'))),
        );
      });
    });
  });
}
