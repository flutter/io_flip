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
        ).toJson(),
        equals({
          'id': '',
          'name': '',
          'description': '',
          'image': '',
          'rarity': false,
          'power': 1,
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
        }),
        equals(
          Card(
            id: '',
            name: '',
            description: '',
            image: '',
            rarity: false,
            power: 1,
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
        ),
        equals(
          Card(
            id: '',
            name: '',
            description: '',
            image: '',
            rarity: false,
            power: 1,
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
            ),
          ),
        ),
      );
    });
  });
}
