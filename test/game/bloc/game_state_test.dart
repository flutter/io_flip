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

    test('copyWith returns a new instance with the copied values', () {
      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ).copyWith(match: match2),
        equals(
          MatchLoadedState(
            match: match2,
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
        ).copyWith(matchState: matchState2),
        equals(
          MatchLoadedState(
            match: match1,
            matchState: matchState2,
            turns: const [],
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ).copyWith(turns: [MatchTurn(playerCardId: '', oponentCardId: '')]),
        equals(
          MatchLoadedState(
            match: match1,
            matchState: matchState1,
            turns: const [MatchTurn(playerCardId: '', oponentCardId: '')],
          ),
        ),
      );
    });

    group('isCardTurnComplete', () {
      final cards = List.generate(
        6,
        (i) => Card(
          id: i.toString(),
          name: '',
          description: '',
          image: '',
          power: 1 + i,
          rarity: false,
        ),
      );

      final baseState = MatchLoadedState(
        match: Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        ),
        matchState: MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: const [],
          guestPlayedCards: const [],
        ),
        turns: const [],
      );

      test('returns true if the turn is complete and the card won', () {
        final state = baseState.copyWith(
          turns: [
            MatchTurn(playerCardId: cards[4].id, oponentCardId: cards[1].id),
          ],
        );
        expect(state.isWiningCard(cards[4]), isTrue);
      });

      test("returns false if the turn is complete but the card didn't win", () {
        final state = baseState.copyWith(
          turns: [
            MatchTurn(playerCardId: cards[2].id, oponentCardId: cards[5].id),
          ],
        );
        expect(state.isWiningCard(cards[2]), isFalse);
      });

      test("returns false if the turn isn't complete", () {
        final state = baseState.copyWith(
          turns: [
            MatchTurn(playerCardId: cards[4].id, oponentCardId: null),
          ],
        );
        expect(state.isWiningCard(cards[4]), isFalse);
      });

      group('when the card is the oponent', () {
        test('returns true if the turn is complete and the card won', () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(playerCardId: cards[0].id, oponentCardId: cards[1].id),
            ],
          );
          expect(state.isWiningCard(cards[1]), isTrue);
        });

        test("returns false if the turn is complete but the card didn't win",
            () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(playerCardId: cards[2].id, oponentCardId: cards[3].id),
            ],
          );
          expect(state.isWiningCard(cards[2]), isFalse);
        });

        test("returns false if the turn isn't complete", () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(playerCardId: null, oponentCardId: cards[1].id),
            ],
          );
          expect(state.isWiningCard(cards[1]), isFalse);
        });
      });
    });

    group('isWiningCard', () {
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

      test('returns true if the card is the winning one', () {
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
