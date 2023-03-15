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
    );
    const card2 = Card(
      id: 'card2',
      name: '',
      description: '',
      image: '',
      rarity: false,
      power: 1,
    );

    test('can be instantiated', () {
      expect(
        Deck(userId: 'userId', id: 'deckId', cards: const [card1, card2]),
        isNotNull,
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        Deck(userId: 'id', id: 'deckId', cards: const [card1, card2]).toJson(),
        equals({
          'userId': 'id',
          'id': 'deckId',
          'cards': [
            {
              'id': 'card1',
              'name': '',
              'description': '',
              'image': '',
              'rarity': false,
              'power': 1,
            },
            {
              'id': 'card2',
              'name': '',
              'description': '',
              'image': '',
              'rarity': false,
              'power': 1,
            },
          ],
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Deck.fromJson(const {
          'userId': 'id',
          'id': 'deckId',
          'cards': [
            {
              'id': 'card1',
              'name': '',
              'description': '',
              'image': '',
              'rarity': false,
              'power': 1,
            },
            {
              'id': 'card2',
              'name': '',
              'description': '',
              'image': '',
              'rarity': false,
              'power': 1,
            },
          ],
        }),
        equals(
          Deck(userId: 'id', id: 'deckId', cards: const [card1, card2]),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Deck(userId: 'id', id: 'deckId', cards: const [card1, card2]),
        equals(
          Deck(userId: 'id', id: 'deckId', cards: const [card1, card2]),
        ),
      );

      expect(
        Deck(userId: 'id', id: 'deckId', cards: const [card1, card2]),
        isNot(
          equals(
            Deck(userId: 'id', id: 'deckId2', cards: const [card2, card1]),
          ),
        ),
      );
    });
  });
}
