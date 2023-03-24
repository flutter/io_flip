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
          hostStartsMatch: true,
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
          hostStartsMatch: true,
          result: MatchResult.host,
        ).toJson(),
        equals({
          'id': 'id',
          'matchId': 'matchId',
          'guestPlayedCards': ['1'],
          'hostPlayedCards': ['2'],
          'hostStartsMatch': 'true',
          'result': 'host',
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
          'hostStartsMatch': 'true',
          'result': 'host',
        }),
        equals(
          MatchState(
            id: 'id',
            matchId: 'matchId',
            guestPlayedCards: const ['1'],
            hostPlayedCards: const ['2'],
            hostStartsMatch: true,
            result: MatchResult.host,
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
          hostStartsMatch: true,
          result: MatchResult.host,
        ),
        equals(
          MatchState(
            id: '',
            matchId: '',
            guestPlayedCards: const [],
            hostPlayedCards: const [],
            hostStartsMatch: true,
            result: MatchResult.host,
          ),
        ),
      );

      expect(
        MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
          hostStartsMatch: true,
        ),
        isNot(
          equals(
            MatchState(
              id: '1',
              matchId: '',
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
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
          hostStartsMatch: true,
        ),
        isNot(
          equals(
            MatchState(
              id: '',
              matchId: '1',
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
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
          hostStartsMatch: true,
        ),
        isNot(
          equals(
            MatchState(
              id: '',
              matchId: '',
              guestPlayedCards: const ['1'],
              hostPlayedCards: const [],
              hostStartsMatch: true,
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
          hostStartsMatch: true,
        ),
        isNot(
          equals(
            MatchState(
              id: '',
              matchId: '',
              guestPlayedCards: const [],
              hostPlayedCards: const ['1'],
              hostStartsMatch: true,
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
          hostStartsMatch: true,
        ),
        isNot(
          equals(
            MatchState(
              id: '',
              matchId: '',
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: false,
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
          hostStartsMatch: true,
        ),
        isNot(
          equals(
            MatchState(
              id: '',
              matchId: '',
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
              result: MatchResult.host,
            ),
          ),
        ),
      );
    });

    test(
        'isOver return true when both players reach the correct '
        'amount of turns', () {
      final finishedMatchState = MatchState(
        id: '',
        matchId: '',
        hostPlayedCards: const ['', '', ''],
        guestPlayedCards: const ['', '', ''],
        hostStartsMatch: true,
      );
      final unfinishedMatchState = MatchState(
        id: '',
        matchId: '',
        hostPlayedCards: const ['', '', ''],
        guestPlayedCards: const ['', ''],
        hostStartsMatch: true,
      );

      expect(finishedMatchState.isOver(), isTrue);
      expect(unfinishedMatchState.isOver(), isFalse);
    });

    test(
        'addHostPlayedCard adds a new card to the host list '
        'in a new instance', () {
      expect(
        MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: const [],
          guestPlayedCards: const [],
          hostStartsMatch: true,
        ).addHostPlayedCard(''),
        equals(
          MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [''],
            guestPlayedCards: const [],
            hostStartsMatch: true,
          ),
        ),
      );
    });

    test(
        'addGuestPlayedCard adds a new card to the guest list '
        'in a new instance', () {
      expect(
        MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: const [],
          guestPlayedCards: const [],
          hostStartsMatch: true,
        ).addGuestPlayedCard(''),
        equals(
          MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [],
            guestPlayedCards: const [''],
            hostStartsMatch: true,
          ),
        ),
      );
    });

    test('setResult sets the result', () {
      expect(
        MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: const [],
          guestPlayedCards: const [],
          hostStartsMatch: true,
        ).setResult(MatchResult.host),
        equals(
          MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [],
            guestPlayedCards: const [],
            hostStartsMatch: true,
            result: MatchResult.host,
          ),
        ),
      );
    });
  });

  group('MatchResult', () {
    group('valueOf', () {
      test('can map host', () {
        expect(MatchResult.valueOf('host'), equals(MatchResult.host));
      });
      test('can map guest', () {
        expect(MatchResult.valueOf('guest'), equals(MatchResult.guest));
      });
      test('can map draw', () {
        expect(MatchResult.valueOf('draw'), equals(MatchResult.draw));
      });
      test('returns null when unknown', () {
        expect(MatchResult.valueOf('a'), isNull);
      });
      test('returns null when null', () {
        expect(MatchResult.valueOf(null), isNull);
      });
    });
  });
}
