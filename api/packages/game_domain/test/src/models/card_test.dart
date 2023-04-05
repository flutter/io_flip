// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Card', () {
    test('can be instantiated', () {
      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.air,
        ),
        isNotNull,
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.air,
        ).toJson(),
        equals({
          'id': '',
          'name': '',
          'description': '',
          'image': '',
          'rarity': false,
          'power': 1,
          'suit': 'air',
          'shareImage': null,
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Card.fromJson(const {
          'id': '',
          'name': '',
          'description': '',
          'image': '',
          'rarity': false,
          'power': 1,
          'suit': 'air',
        }),
        equals(
          Card(
            id: '',
            name: '',
            description: '',
            image: '',
            rarity: false,
            power: 1,
            suit: Suit.air,
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.air,
        ),
        equals(
          Card(
            id: '',
            name: '',
            description: '',
            image: '',
            rarity: false,
            power: 1,
            suit: Suit.air,
          ),
        ),
      );

      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.air,
        ),
        isNot(
          equals(
            Card(
              id: '1',
              name: '',
              description: '',
              image: '',
              rarity: false,
              power: 1,
              suit: Suit.air,
            ),
          ),
        ),
      );

      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.air,
        ),
        isNot(
          equals(
            Card(
              id: '',
              name: 'a',
              description: '',
              image: '',
              rarity: false,
              power: 1,
              suit: Suit.air,
            ),
          ),
        ),
      );

      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.air,
        ),
        isNot(
          equals(
            Card(
              id: '',
              name: '',
              description: 'a',
              image: '',
              rarity: false,
              power: 1,
              suit: Suit.air,
            ),
          ),
        ),
      );

      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.air,
        ),
        isNot(
          equals(
            Card(
              id: '',
              name: '',
              description: '',
              image: 'a',
              rarity: false,
              power: 1,
              suit: Suit.air,
            ),
          ),
        ),
      );

      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.air,
        ),
        isNot(
          equals(
            Card(
              id: '',
              name: '',
              description: '',
              image: '',
              rarity: false,
              power: 2,
              suit: Suit.air,
            ),
          ),
        ),
      );

      expect(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          rarity: false,
          power: 1,
          suit: Suit.fire,
        ),
        isNot(
          equals(
            Card(
              id: '',
              name: '',
              description: '',
              image: '',
              rarity: false,
              power: 1,
              suit: Suit.air,
            ),
          ),
        ),
      );
    });

    test(
      'copyWithShareImage returns the instance with the new shareImage value',
      () {
        expect(
          Card(
            id: '',
            name: '',
            description: '',
            image: '',
            rarity: false,
            power: 1,
            suit: Suit.air,
          ).copyWithShareImage('a'),
          equals(
            Card(
              id: '',
              name: '',
              description: '',
              image: '',
              rarity: false,
              power: 1,
              suit: Suit.air,
              shareImage: 'a',
            ),
          ),
        );
      },
    );
  });
}
