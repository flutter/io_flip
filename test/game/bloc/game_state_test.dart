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
    );

    final matchState2 = MatchState(
      id: 'matchState2',
      matchId: match2.id,
      hostPlayedCards: const [],
      guestPlayedCards: const [],
    );

    test('can be instantiated', () {
      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
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
          rounds: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            rounds: const [],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isClashScene: false,
            showCardLanding: false,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match2,
              matchState: matchState1,
              rounds: const [],
              turnAnimationsFinished: false,
              turnTimeRemaining: 10,
              isClashScene: false,
              showCardLanding: false,
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match1,
              matchState: matchState2,
              rounds: const [],
              turnAnimationsFinished: false,
              turnTimeRemaining: 10,
              isClashScene: false,
              showCardLanding: false,
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match1,
              matchState: matchState1,
              rounds: const [
                MatchRound(
                  opponentCardId: '',
                  playerCardId: '',
                ),
              ],
              turnAnimationsFinished: false,
              turnTimeRemaining: 10,
              isClashScene: false,
              showCardLanding: false,
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match1,
              matchState: matchState1,
              rounds: const [],
              turnAnimationsFinished: true,
              turnTimeRemaining: 10,
              isClashScene: false,
              showCardLanding: false,
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ),
        isNot(
          equals(
            MatchLoadedState(
              playerScoreCard: ScoreCard(id: 'scoreCardId'),
              match: match1,
              matchState: matchState1,
              rounds: const [],
              turnAnimationsFinished: false,
              turnTimeRemaining: 9,
              isClashScene: false,
              showCardLanding: false,
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
          rounds: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ).copyWith(match: match2),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match2,
            matchState: matchState1,
            rounds: const [],
            turnAnimationsFinished: true,
            turnTimeRemaining: 10,
            isClashScene: false,
            showCardLanding: false,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ).copyWith(matchState: matchState2),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState2,
            rounds: const [],
            turnAnimationsFinished: true,
            turnTimeRemaining: 10,
            isClashScene: false,
            showCardLanding: false,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ).copyWith(rounds: [MatchRound(playerCardId: '', opponentCardId: '')]),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            rounds: const [MatchRound(playerCardId: '', opponentCardId: '')],
            turnAnimationsFinished: true,
            turnTimeRemaining: 10,
            isClashScene: false,
            showCardLanding: false,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ).copyWith(turnAnimationsFinished: false),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            rounds: const [],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isClashScene: false,
            showCardLanding: false,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ).copyWith(turnTimeRemaining: 9),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            rounds: const [],
            turnAnimationsFinished: true,
            turnTimeRemaining: 9,
            isClashScene: false,
            showCardLanding: false,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ).copyWith(isClashScene: true),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            rounds: const [],
            turnAnimationsFinished: true,
            turnTimeRemaining: 10,
            isClashScene: true,
            showCardLanding: false,
          ),
        ),
      );

      expect(
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          rounds: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
          isClashScene: false,
          showCardLanding: false,
        ).copyWith(showCardLanding: true),
        equals(
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: match1,
            matchState: matchState1,
            rounds: const [],
            turnAnimationsFinished: true,
            turnTimeRemaining: 10,
            isClashScene: false,
            showCardLanding: true,
          ),
        ),
      );
    });
  });

  group('MatchRound', () {
    test('can be instantiated', () {
      expect(
        MatchRound(playerCardId: null, opponentCardId: null),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        MatchRound(playerCardId: null, opponentCardId: null),
        equals(MatchRound(playerCardId: null, opponentCardId: null)),
      );

      expect(
        MatchRound(playerCardId: null, opponentCardId: null),
        equals(
          isNot(
            MatchRound(playerCardId: '1', opponentCardId: null),
          ),
        ),
      );

      expect(
        MatchRound(playerCardId: null, opponentCardId: null),
        equals(
          isNot(
            MatchRound(playerCardId: null, opponentCardId: '1'),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the copied values', () {
      expect(
        MatchRound(
          playerCardId: 'player',
          opponentCardId: 'opponent',
        ).copyWith(),
        equals(
          MatchRound(
            playerCardId: 'player',
            opponentCardId: 'opponent',
          ),
        ),
      );

      expect(
        MatchRound(
          playerCardId: 'player',
          opponentCardId: 'opponent',
        ).copyWith(playerCardId: ''),
        equals(
          MatchRound(
            playerCardId: '',
            opponentCardId: 'opponent',
          ),
        ),
      );

      expect(
        MatchRound(
          playerCardId: 'player',
          opponentCardId: 'opponent',
        ).copyWith(opponentCardId: ''),
        equals(
          MatchRound(
            playerCardId: 'player',
            opponentCardId: '',
          ),
        ),
      );

      expect(
        MatchRound(
          playerCardId: 'player',
          opponentCardId: 'opponent',
        ).copyWith(showCardsOverlay: true),
        equals(
          MatchRound(
            playerCardId: 'player',
            opponentCardId: 'opponent',
            showCardsOverlay: true,
          ),
        ),
      );
    });
  });

  group('LeaderboardEntryState', () {
    test('can be instantiated', () {
      expect(
        LeaderboardEntryState('scoreCardId'),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        LeaderboardEntryState('scoreCardId'),
        equals(LeaderboardEntryState('scoreCardId')),
      );

      expect(
        LeaderboardEntryState('scoreCardId'),
        equals(
          isNot(
            LeaderboardEntryState('scoreCardId2'),
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
