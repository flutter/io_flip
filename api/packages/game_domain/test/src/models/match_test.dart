// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Match', () {
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

    const hostDeck = Deck(
      id: 'hostDeck',
      cards: [card1],
    );

    const guestDeck = Deck(
      id: 'guestDeck',
      cards: [card2],
    );

    test('can be instantiated', () {
      expect(
        Match(
          id: 'matchId',
          hostDeck: hostDeck,
          guestDeck: guestDeck,
        ),
        isNotNull,
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        Match(
          id: 'matchId',
          hostDeck: hostDeck,
          guestDeck: guestDeck,
        ).toJson(),
        equals({
          'id': 'matchId',
          'hostDeck': {
            'id': 'hostDeck',
            'cards': [
              {
                'id': 'card1',
                'name': '',
                'description': '',
                'image': '',
                'rarity': false,
                'power': 1,
              },
            ],
          },
          'guestDeck': {
            'id': 'guestDeck',
            'cards': [
              {
                'id': 'card2',
                'name': '',
                'description': '',
                'image': '',
                'rarity': false,
                'power': 1,
              },
            ],
          }
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Match.fromJson(const {
          'id': 'matchId',
          'hostDeck': {
            'id': 'hostDeck',
            'cards': [
              {
                'id': 'card1',
                'name': '',
                'description': '',
                'image': '',
                'rarity': false,
                'power': 1,
              },
            ],
          },
          'guestDeck': {
            'id': 'guestDeck',
            'cards': [
              {
                'id': 'card2',
                'name': '',
                'description': '',
                'image': '',
                'rarity': false,
                'power': 1,
              },
            ],
          }
        }),
        equals(
          Match(
            id: 'matchId',
            hostDeck: hostDeck,
            guestDeck: guestDeck,
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        Match(
          id: 'matchId',
          hostDeck: hostDeck,
          guestDeck: guestDeck,
        ),
        equals(
          Match(
            id: 'matchId',
            hostDeck: hostDeck,
            guestDeck: guestDeck,
          ),
        ),
      );

      expect(
        Match(
          id: 'matchId',
          hostDeck: hostDeck,
          guestDeck: guestDeck,
        ),
        isNot(
          equals(
            Match(
              id: 'matchId2',
              hostDeck: hostDeck,
              guestDeck: guestDeck,
            ),
          ),
        ),
      );

      expect(
        Match(
          id: 'matchId',
          hostDeck: hostDeck,
          guestDeck: guestDeck,
        ),
        isNot(
          equals(
            Match(
              id: 'matchId',
              hostDeck: guestDeck,
              guestDeck: hostDeck,
            ),
          ),
        ),
      );
    });
  });
}
