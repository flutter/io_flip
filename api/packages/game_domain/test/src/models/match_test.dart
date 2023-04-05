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

    const hostDeck = Deck(
      id: 'hostDeck',
      userId: 'hostUserId',
      cards: [card1],
    );

    const guestDeck = Deck(
      id: 'guestDeck',
      userId: 'guestUserId',
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
            'userId': 'hostUserId',
            'cards': [
              {
                'id': 'card1',
                'name': '',
                'description': '',
                'image': '',
                'rarity': false,
                'power': 1,
                'suit': 'air',
                'shareImage': null,
              },
            ],
            'shareImage': null,
          },
          'guestDeck': {
            'id': 'guestDeck',
            'userId': 'guestUserId',
            'cards': [
              {
                'id': 'card2',
                'name': '',
                'description': '',
                'image': '',
                'rarity': false,
                'power': 1,
                'suit': 'fire',
                'shareImage': null,
              },
            ],
            'shareImage': null,
          },
          'hostConnected': false,
          'guestConnected': false
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Match.fromJson(const {
          'id': 'matchId',
          'hostDeck': {
            'id': 'hostDeck',
            'userId': 'hostUserId',
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
            ],
          },
          'guestDeck': {
            'id': 'guestDeck',
            'userId': 'guestUserId',
            'cards': [
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
