// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/game/game.dart';

void main() {
  group('GameEvent', () {
    const deck = Deck(id: 'deckId', userId: 'userId', cards: []);
    group('MatchRequested', () {
      test('can be instantiated', () {
        expect(MatchRequested('match1', deck), isNotNull);
      });

      test('supports equality', () {
        expect(
          MatchRequested('match1', deck),
          equals(MatchRequested('match1', deck)),
        );

        expect(
          MatchRequested('match1', deck),
          isNot(equals(MatchRequested('match2', deck))),
        );

        expect(
          MatchRequested('match1', deck),
          isNot(
            equals(
              MatchRequested(
                'match1',
                Deck(id: '', userId: '', cards: const []),
              ),
            ),
          ),
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
      );
      const matchState2 = MatchState(
        id: '2',
        matchId: '',
        hostPlayedCards: [],
        guestPlayedCards: [],
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
        expect(ManagePlayerPresence('match1', deck), isNotNull);
      });

      test('supports equality', () {
        expect(
          ManagePlayerPresence('match1', deck),
          equals(ManagePlayerPresence('match1', deck)),
        );

        expect(
          ManagePlayerPresence('match1', deck),
          isNot(equals(ManagePlayerPresence('match2', deck))),
        );

        expect(
          ManagePlayerPresence('match1', deck),
          isNot(
            equals(
              ManagePlayerPresence(
                'match1',
                Deck(id: '', userId: '', cards: const []),
              ),
            ),
          ),
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

    group('ClashSceneCompleted', () {
      test('can be instantiated', () {
        expect(ClashSceneCompleted(), isNotNull);
      });

      test('supports equality', () {
        expect(
          ClashSceneCompleted(),
          equals(ClashSceneCompleted()),
        );
      });
    });

    group('ClashSceneStarted', () {
      test('can be instantiated', () {
        expect(ClashSceneStarted(), isNotNull);
      });

      test('supports equality', () {
        expect(
          ClashSceneStarted(),
          equals(ClashSceneStarted()),
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

    group('CardLandingStarted', () {
      test('can be instantiated', () {
        expect(CardLandingStarted(), isNotNull);
      });

      test('supports equality', () {
        expect(
          CardLandingStarted(),
          equals(CardLandingStarted()),
        );
      });
    });

    group('CardLandingCompleted', () {
      test('can be instantiated', () {
        expect(CardLandingCompleted(), isNotNull);
      });

      test('supports equality', () {
        expect(
          CardLandingCompleted(),
          equals(CardLandingCompleted()),
        );
      });
    });
  });
}
