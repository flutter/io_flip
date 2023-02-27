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
  );

  const card2 = Card(
    id: '2',
    name: '',
    description: '',
    rarity: true,
    image: '',
    power: 1,
  );

  group('DraftState', () {
    test('can be instantiated', () {
      expect(
        DraftState(
          cards: const [],
          status: DraftStateStatus.initial,
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
            status: DraftStateStatus.initial,
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        DraftState(
          cards: const [],
          status: DraftStateStatus.initial,
        ),
        equals(
          DraftState(
            cards: const [],
            status: DraftStateStatus.initial,
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [card1],
          status: DraftStateStatus.initial,
        ),
        isNot(
          equals(
            DraftState(
              cards: const [card2],
              status: DraftStateStatus.initial,
            ),
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [],
          status: DraftStateStatus.initial,
        ),
        isNot(
          equals(
            DraftState(
              cards: const [],
              status: DraftStateStatus.cardLoading,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance', () {
      expect(
        DraftState(
          cards: const [],
          status: DraftStateStatus.initial,
        ).copyWith(cards: [card1, card2]),
        equals(
          DraftState(
            cards: const [card1, card2],
            status: DraftStateStatus.initial,
          ),
        ),
      );

      expect(
        DraftState(
          cards: const [],
          status: DraftStateStatus.initial,
        ).copyWith(status: DraftStateStatus.cardLoaded),
        equals(
          DraftState(
            cards: const [],
            status: DraftStateStatus.cardLoaded,
          ),
        ),
      );
    });
  });
}
