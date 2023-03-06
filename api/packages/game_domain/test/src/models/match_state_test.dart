// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('MatchState', () {
    test('can be instantiated', () {
      expect(
        MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
        ),
        isNotNull,
      );
    });

    test('toJson returns the instance as json', () {
      expect(
        MatchState(
          id: 'id',
          matchId: 'matchId',
          guestPlayedCards: const ['1'],
          hostPlayedCards: const ['2'],
        ).toJson(),
        equals({
          'id': 'id',
          'matchId': 'matchId',
          'guestPlayedCards': ['1'],
          'hostPlayedCards': ['2'],
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        MatchState.fromJson(const {
          'id': 'id',
          'matchId': 'matchId',
          'guestPlayedCards': ['1'],
          'hostPlayedCards': ['2'],
        }),
        equals(
          MatchState(
            id: 'id',
            matchId: 'matchId',
            guestPlayedCards: const ['1'],
            hostPlayedCards: const ['2'],
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
        ),
        equals(
          MatchState(
            id: '',
            matchId: '',
            guestPlayedCards: const [],
            hostPlayedCards: const [],
          ),
        ),
      );

      expect(
        MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
        ),
        isNot(
          equals(
            MatchState(
              id: '1',
              matchId: '',
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
          ),
        ),
      );

      expect(
        MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
        ),
        isNot(
          equals(
            MatchState(
              id: '',
              matchId: '1',
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
          ),
        ),
      );

      expect(
        MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
        ),
        isNot(
          equals(
            MatchState(
              id: '',
              matchId: '',
              guestPlayedCards: const ['1'],
              hostPlayedCards: const [],
            ),
          ),
        ),
      );

      expect(
        MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
        ),
        isNot(
          equals(
            MatchState(
              id: '',
              matchId: '',
              guestPlayedCards: const [],
              hostPlayedCards: const ['1'],
            ),
          ),
        ),
      );
    });
  });
}
