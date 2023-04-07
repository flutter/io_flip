// ignore_for_file: prefer_const_constructors

import 'dart:async';

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

    group('LeaderboardEntryRequested', () {
      test('can be instantiated', () {
        expect(LeaderboardEntryRequested(), isNotNull);
      });

      test('supports equality', () {
        expect(
          LeaderboardEntryRequested(),
          equals(LeaderboardEntryRequested()),
        );
      });
    });

    group('TurnTimerStarted', () {
      test('can be instantiated', () {
        expect(TurnTimerStarted(), isNotNull);
      });

      test('supports equality', () {
        expect(
          TurnTimerStarted(),
          equals(TurnTimerStarted()),
        );
      });
    });

    group('TurnTimerTicked', () {
      final timer1 = Timer.periodic(Duration.zero, (t) {});
      final timer2 = Timer.periodic(Duration(seconds: 1), (t) {});
      test('can be instantiated', () {
        expect(TurnTimerTicked(timer1), isNotNull);
      });

      test('supports equality', () {
        expect(
          TurnTimerTicked(timer1),
          equals(TurnTimerTicked(timer1)),
        );

        expect(
          TurnTimerTicked(timer1),
          isNot(equals(TurnTimerTicked(timer2))),
        );
      });
    });

    group('CardOverlayRevealed', () {
      test('can be instantiated', () {
        expect(CardOverlayRevealed(), isNotNull);
      });

      test('supports equality', () {
        expect(
          CardOverlayRevealed(),
          equals(CardOverlayRevealed()),
        );
      });
    });

    group('TurnAnimationsFinished', () {
      test('can be instantiated', () {
        expect(TurnAnimationsFinished(), isNotNull);
      });

      test('supports equality', () {
        expect(
          TurnAnimationsFinished(),
          equals(TurnAnimationsFinished()),
        );
      });
    });
  });
}
