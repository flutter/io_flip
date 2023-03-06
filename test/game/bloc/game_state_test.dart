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
      hostDeck: Deck(id: '', cards: const []),
      guestDeck: Deck(id: '', cards: const []),
    );

    final match2 = Match(
      id: 'match2',
      hostDeck: Deck(id: '', cards: const []),
      guestDeck: Deck(id: '', cards: const []),
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
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        equals(
          MatchLoadedState(
            match: match1,
            matchState: matchState1,
            turns: const [],
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        isNot(
          equals(
            MatchLoadedState(
              match: match2,
              matchState: matchState1,
              turns: const [],
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        isNot(
          equals(
            MatchLoadedState(
              match: match1,
              matchState: matchState2,
              turns: const [],
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        isNot(
          equals(
            MatchLoadedState(
              match: match1,
              matchState: matchState1,
              turns: const [
                MatchTurn(
                  oponentCardId: '',
                  playerCardId: '',
                ),
              ],
            ),
          ),
        ),
      );
    });

    group('isCardTurnComplete', () {

      final card = Card(
        id: '1',
        name: '',
        description: '',
        image: '',
        power: 10,
        rarity: false,
      );

      final baseState = MatchLoadedState(
        match: match1,
        matchState: matchState1,
        turns: const [],
      );

      test('returns true if the turn is complete', () {
        final state = baseState.copyWith(
          turns: [
            MatchTurn(
              oponentCardId: card.id,
              playerCardId: 'a',
            ),
          ],
        );

        expect(state.isCardTurnComplete(card), isTrue);
      });

      test('returns false if the turn is not complete', () {
        final state = baseState.copyWith(
          turns: [
            MatchTurn(
              oponentCardId: card.id,
              playerCardId: null,
            ),
          ],
        );

        expect(state.isCardTurnComplete(card), isFalse);
      });

      test('can detect the card turn no matter the order', () {
        final state = baseState.copyWith(
          turns: [
            MatchTurn(
              oponentCardId: 'a',
              playerCardId: card.id,
            ),
            MatchTurn(
              oponentCardId: 'b',
              playerCardId: null,
            ),
          ],
        );

        expect(state.isCardTurnComplete(card), isTrue);
      });
    });
  });

  group('MatchTurn', () {
    test('can be instantiated', () {
      expect(
        MatchTurn(playerCardId: null, oponentCardId: null),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        MatchTurn(playerCardId: null, oponentCardId: null),
        equals(MatchTurn(playerCardId: null, oponentCardId: null)),
      );

      expect(
        MatchTurn(playerCardId: null, oponentCardId: null),
        equals(
          isNot(
            MatchTurn(playerCardId: '1', oponentCardId: null),
          ),
        ),
      );

      expect(
        MatchTurn(playerCardId: null, oponentCardId: null),
        equals(
          isNot(
            MatchTurn(playerCardId: null, oponentCardId: '1'),
          ),
        ),
      );
    });

    test('isComplete', () {
      expect(
        MatchTurn(playerCardId: null, oponentCardId: null).isComplete(),
        isFalse,
      );

      expect(
        MatchTurn(playerCardId: 'a', oponentCardId: null).isComplete(),
        isFalse,
      );

      expect(
        MatchTurn(playerCardId: null, oponentCardId: 'a').isComplete(),
        isFalse,
      );

      expect(
        MatchTurn(playerCardId: 'b', oponentCardId: 'a').isComplete(),
        isTrue,
      );
    });
  });
}
