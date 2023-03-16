// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Deck', () {
    const card1 = Card(
      id: 'card1',
      name: '',
      description: '',
      image: '',
      rarity: false,
      power: 1,
      suit: Suit.air,
    );
    const card2 = Card(
      id: 'card2',
      name: '',
      description: '',
      image: '',
      rarity: false,
      power: 1,
      suit: Suit.fire,
    );

    test('can be instantiated', () {
      expect(
        Deck(
          id: 'deckId',
          userId: 'userId',
          cards: const [card1, card2],
        ),
        isNotNull,
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        Deck(
          id: 'deckId',
          userId: 'userId',
          cards: const [card1, card2],
        ).toJson(),
        equals({
          'id': 'deckId',
          'userId': 'userId',
          'cards': [
            {
              'id': 'card1',
              'name': '',
              'description': '',
              'image': '',
              'rarity': false,
              'power': 1,
              'suit': 'air',
            },
            {
              'id': 'card2',
              'name': '',
              'description': '',
              'image': '',
              'rarity': false,
              'power': 1,
              'suit': 'fire',
            },
          ],
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Deck.fromJson(const {
          'id': 'deckId',
          'userId': 'userId',
          'cards': [
            {
              'id': 'card1',
              'name': '',
              'description': '',
              'image': '',
              'rarity': false,
              'power': 1,
              'suit': 'air',
            },
            {
              'id': 'card2',
              'name': '',
              'description': '',
              'image': '',
              'rarity': false,
              'power': 1,
              'suit': 'fire',
            },
          ],
        }),
        equals(
          Deck(
            id: 'deckId',
            userId: 'userId',
            cards: const [card1, card2],
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Deck(
          id: 'deckId',
          userId: 'userId',
          cards: const [card1, card2],
        ),
        equals(
          Deck(
            id: 'deckId',
            userId: 'userId',
            cards: const [card1, card2],
          ),
        ),
      );

      expect(
        Deck(
          id: 'deckId',
          userId: 'userId',
          cards: const [card1, card2],
        ),
        isNot(
          equals(
            Deck(
              id: 'deckId2',
              userId: 'userId',
              cards: const [card2, card1],
            ),
          ),
        ),
      );
    });
  });
}
