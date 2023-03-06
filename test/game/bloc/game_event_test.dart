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

    group('PlayerPlayed', () {
      test('can be instantiated', () {
        expect(PlayerPlayed('cardId'), isNotNull);
      });

      test('supports equality', () {
        expect(
          PlayerPlayed('card1'),
          equals(PlayerPlayed('card1')),
        );

        expect(
          PlayerPlayed('card1'),
          isNot(equals(PlayerPlayed('card2'))),
        );
      });
    });

    group('OponentPlayed', () {
      test('can be instantiated', () {
        expect(OponentPlayed('cardId'), isNotNull);
      });

      test('supports equality', () {
        expect(
          OponentPlayed('card1'),
          equals(OponentPlayed('card1')),
        );

        expect(
          OponentPlayed('card1'),
          isNot(equals(OponentPlayed('card2'))),
        );
      });
    });
    group('OponentPlayed', () {
      test('can be instantiated', () {
        expect(OponentPlayed('cardId'), isNotNull);
      });

      test('supports equality', () {
        expect(
          OponentPlayed('card1'),
          equals(OponentPlayed('card1')),
        );

        expect(
          OponentPlayed('card1'),
          isNot(equals(OponentPlayed('card2'))),
        );
      });
    });
  });
}
