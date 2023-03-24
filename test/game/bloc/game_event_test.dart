// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
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

    group('MatchStateUpdated', () {
      const matchState1 = MatchState(
        id: '1',
        matchId: '',
        hostPlayedCards: [],
        guestPlayedCards: [],
        hostStartsMatch: true,
      );
      const matchState2 = MatchState(
        id: '2',
        matchId: '',
        hostPlayedCards: [],
        guestPlayedCards: [],
        hostStartsMatch: true,
      );
      test('can be instantiated', () {
        expect(MatchStateUpdated(matchState1), isNotNull);
      });

      test('supports equality', () {
        expect(
          MatchStateUpdated(matchState1),
          equals(MatchStateUpdated(matchState1)),
        );

        expect(
          MatchStateUpdated(matchState1),
          isNot(equals(MatchStateUpdated(matchState2))),
        );
      });
    });

    group('ScoreUpdated', () {
      const scoreCard1 = ScoreCard(id: '1');
      const scoreCard2 = ScoreCard(id: '2');
      test('can be instantiated', () {
        expect(ScoreCardUpdated(scoreCard1), isNotNull);
      });

      test('supports equality', () {
        expect(
          ScoreCardUpdated(scoreCard1),
          equals(ScoreCardUpdated(scoreCard1)),
        );

        expect(
          ScoreCardUpdated(scoreCard1),
          isNot(equals(ScoreCardUpdated(scoreCard2))),
        );
      });
    });

    group('PresenceCheckRequested', () {
      test('can be instantiated', () {
        expect(ManagePlayerPresence('match1'), isNotNull);
      });

      test('supports equality', () {
        expect(
          ManagePlayerPresence('match1'),
          equals(ManagePlayerPresence('match1')),
        );

        expect(
          ManagePlayerPresence('match1'),
          isNot(equals(ManagePlayerPresence('match2'))),
        );
      });
    });
  });
}
