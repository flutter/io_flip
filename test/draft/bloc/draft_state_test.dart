// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/draft/draft.dart';

void main() {
  const card1 = Card(
    id: '1',
    name: '',
    description: '',
    rarity: true,
    image: '',
    power: 1,
    suit: Suit.air,
  );

  const card2 = Card(
    id: '2',
    name: '',
    description: '',
    rarity: true,
    image: '',
    power: 1,
    suit: Suit.air,
  );

  group('DraftState', () {
    test('can be instantiated', () {
      expect(
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        DraftState.initial(),
        equals(
          DraftState(
            cards: const [],
            selectedCards: const [],
            status: DraftStateStatus.initial,
            firstCardOpacity: 1,
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ),
        equals(
          DraftState(
            cards: const [],
            selectedCards: const [],
            status: DraftStateStatus.initial,
            firstCardOpacity: 1,
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [card1],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ),
        isNot(
          equals(
            DraftState(
              cards: const [card2],
              selectedCards: const [],
              status: DraftStateStatus.initial,
              firstCardOpacity: 1,
            ),
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [],
          selectedCards: const [card1],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ),
        isNot(
          equals(
            DraftState(
              cards: const [],
              selectedCards: const [card2],
              status: DraftStateStatus.initial,
              firstCardOpacity: 1,
            ),
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ),
        isNot(
          equals(
            DraftState(
              cards: const [],
              selectedCards: const [],
              status: DraftStateStatus.deckLoading,
              firstCardOpacity: 1,
            ),
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ),
        isNot(
          equals(
            DraftState(
              cards: const [],
              selectedCards: const [],
              status: DraftStateStatus.initial,
              firstCardOpacity: .8,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance', () {
      expect(
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ).copyWith(cards: [card1, card2]),
        equals(
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.initial,
            firstCardOpacity: 1,
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ).copyWith(selectedCards: [card1, card2]),
        equals(
          DraftState(
            cards: const [],
            selectedCards: const [card1, card2],
            status: DraftStateStatus.initial,
            firstCardOpacity: 1,
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ).copyWith(status: DraftStateStatus.deckLoaded),
        equals(
          DraftState(
            cards: const [],
            selectedCards: const [],
            status: DraftStateStatus.deckLoaded,
            firstCardOpacity: 1,
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.initial,
          firstCardOpacity: 1,
        ).copyWith(firstCardOpacity: .8),
        equals(
          DraftState(
            cards: const [],
            selectedCards: const [],
            status: DraftStateStatus.initial,
            firstCardOpacity: .8,
          ),
        ),
      );
    });
  });
}
