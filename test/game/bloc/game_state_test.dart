// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/game/game.dart';

void main() {
  group('MatchLoadingState', () {
    test('can be instantiated', () {
      expect(MatchLoadingState(), isNotNull);
    });

    test('supports equality', () {
      expect(
        MatchLoadingState(),
        equals(MatchLoadingState()),
      );
    });
  });

  group('MatchLoadFailedState', () {
    test('can be instantiated', () {
      expect(MatchLoadFailedState(), isNotNull);
    });

    test('supports equality', () {
      expect(
        MatchLoadFailedState(),
        equals(MatchLoadFailedState()),
      );
    });
  });

  group('MatchLoadedState', () {
    final match1 = Match(
      id: 'match1',
      hostDeck: Deck(id: '', userId: '', cards: const []),
      guestDeck: Deck(id: '', userId: '', cards: const []),
    );

    final match2 = Match(
      id: 'match2',
      hostDeck: Deck(id: '', userId: '', cards: const []),
      guestDeck: Deck(id: '', userId: '', cards: const []),
    );

    final matchState1 = MatchState(
      id: 'matchState1',
      matchId: match1.id,
      hostPlayedCards: const [],
      guestPlayedCards: const [],
      hostStartsMatch: true,
    );

    final matchState2 = MatchState(
      id: 'matchState2',
      matchId: match2.id,
      hostPlayedCards: const [],
      guestPlayedCards: const [],
      hostStartsMatch: true,
    );

    test('can be instantiated', () {
      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
        ),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            turns: const [],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match2,
              matchState: matchState1,
              turns: const [],
              turnAnimationsFinished: false,
              turnTimeRemaining: 10,
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match1,
              matchState: matchState2,
              turns: const [],
              turnAnimationsFinished: false,
              turnTimeRemaining: 10,
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match1,
              matchState: matchState1,
              turns: const [
                MatchTurn(
                  opponentCardId: '',
                  playerCardId: '',
                ),
              ],
              turnAnimationsFinished: false,
              turnTimeRemaining: 10,
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match1,
              matchState: matchState1,
              turns: const [],
              turnAnimationsFinished: true,
              turnTimeRemaining: 10,
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match1,
              matchState: matchState1,
              turns: const [],
              turnAnimationsFinished: false,
              turnTimeRemaining: 9,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the copied values', () {
      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
        ).copyWith(match: match2),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match2,
            matchState: matchState1,
            turns: const [],
            turnAnimationsFinished: true,
            turnTimeRemaining: 10,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
        ).copyWith(matchState: matchState2),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState2,
            turns: const [],
            turnAnimationsFinished: true,
            turnTimeRemaining: 10,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
        ).copyWith(turns: [MatchTurn(playerCardId: '', opponentCardId: '')]),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            turns: const [MatchTurn(playerCardId: '', opponentCardId: '')],
            turnAnimationsFinished: true,
            turnTimeRemaining: 10,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
        ).copyWith(turnAnimationsFinished: false),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            turns: const [],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
        ).copyWith(turnTimeRemaining: 9),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            turns: const [],
            turnAnimationsFinished: true,
            turnTimeRemaining: 9,
          ),
        ),
      );
    });
  });

  group('MatchTurn', () {
    test('can be instantiated', () {
      expect(
        MatchTurn(playerCardId: null, opponentCardId: null),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        MatchTurn(playerCardId: null, opponentCardId: null),
        equals(MatchTurn(playerCardId: null, opponentCardId: null)),
      );

      expect(
        MatchTurn(playerCardId: null, opponentCardId: null),
        equals(
          isNot(
            MatchTurn(playerCardId: '1', opponentCardId: null),
          ),
        ),
      );

      expect(
        MatchTurn(playerCardId: null, opponentCardId: null),
        equals(
          isNot(
            MatchTurn(playerCardId: null, opponentCardId: '1'),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the copied values', () {
      expect(
        MatchTurn(
          playerCardId: 'player',
          opponentCardId: 'opponent',
        ).copyWith(),
        equals(
          MatchTurn(
            playerCardId: 'player',
            opponentCardId: 'opponent',
          ),
        ),
      );

      expect(
        MatchTurn(
          playerCardId: 'player',
          opponentCardId: 'opponent',
        ).copyWith(playerCardId: ''),
        equals(
          MatchTurn(
            playerCardId: '',
            opponentCardId: 'opponent',
          ),
        ),
      );

      expect(
        MatchTurn(
          playerCardId: 'player',
          opponentCardId: 'opponent',
        ).copyWith(opponentCardId: ''),
        equals(
          MatchTurn(
            playerCardId: 'player',
            opponentCardId: '',
          ),
        ),
      );

      expect(
        MatchTurn(
          playerCardId: 'player',
          opponentCardId: 'opponent',
        ).copyWith(showCardsOverlay: true),
        equals(
          MatchTurn(
            playerCardId: 'player',
            opponentCardId: 'opponent',
            showCardsOverlay: true,
          ),
        ),
      );
    });
  });

  group('OpponentAbsentState', () {
    test('can be instantiated', () {
      expect(OpponentAbsentState(), isNotNull);
    });

    test('supports equality', () {
      expect(
        OpponentAbsentState(),
        equals(OpponentAbsentState()),
      );
    });
  });

  group('CheckOpponentPresenceFailedState', () {
    test('can be instantiated', () {
      expect(ManagePlayerPresenceFailedState(), isNotNull);
    });

    test('supports equality', () {
      expect(
        ManagePlayerPresenceFailedState(),
        equals(ManagePlayerPresenceFailedState()),
      );
    });
  });
}
