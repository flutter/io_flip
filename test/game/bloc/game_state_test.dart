// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/game/game.dart';

void main() {
  group('MatchLoadingState', () {
    test('can be instantiated', () {
      expect(MatchLoadingState(), isNotNull);
    });

    test('supports equality', () {
      expect(
        MatchLoadingState(),
        equals(MatchLoadingState()),
      );
    });
  });

  group('MatchLoadFailedState', () {
    test('can be instantiated', () {
      expect(MatchLoadFailedState(), isNotNull);
    });

    test('supports equality', () {
      expect(
        MatchLoadFailedState(),
        equals(MatchLoadFailedState()),
      );
    });
  });

  group('MatchLoadedState', () {
    final match1 = Match(
      id: 'match1',
      hostDeck: Deck(id: '', cards: const []),
      guestDeck: Deck(id: '', cards: const []),
    );

    final match2 = Match(
      id: 'match2',
      hostDeck: Deck(id: '', cards: const []),
      guestDeck: Deck(id: '', cards: const []),
    );

    final matchState1 = MatchState(
      id: 'matchState1',
      matchId: match1.id,
      hostPlayedCards: const [],
      guestPlayedCards: const [],
    );

    final matchState2 = MatchState(
      id: 'matchState2',
      matchId: match2.id,
      hostPlayedCards: const [],
      guestPlayedCards: const [],
    );

    test('can be instantiated', () {
      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        equals(
          MatchLoadedState(
            match: match1,
            matchState: matchState1,
            turns: const [],
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        isNot(
          equals(
            MatchLoadedState(
              match: match2,
              matchState: matchState1,
              turns: const [],
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        isNot(
          equals(
            MatchLoadedState(
              match: match1,
              matchState: matchState2,
              turns: const [],
            ),
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ),
        isNot(
          equals(
            MatchLoadedState(
              match: match1,
              matchState: matchState1,
              turns: const [
                MatchTurn(
                  oponentCardId: '',
                  playerCardId: '',
                ),
              ],
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the copied values', () {
      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ).copyWith(match: match2),
        equals(
          MatchLoadedState(
            match: match2,
            matchState: matchState1,
            turns: const [],
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ).copyWith(matchState: matchState2),
        equals(
          MatchLoadedState(
            match: match1,
            matchState: matchState2,
            turns: const [],
          ),
        ),
      );

      expect(
        MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
        ).copyWith(turns: [MatchTurn(playerCardId: '', oponentCardId: '')]),
        equals(
          MatchLoadedState(
            match: match1,
            matchState: matchState1,
            turns: const [MatchTurn(playerCardId: '', oponentCardId: '')],
          ),
        ),
      );
    });
  });

  group('MatchTurn', () {
    test('can be instantiated', () {
      expect(
        MatchTurn(playerCardId: null, oponentCardId: null),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        MatchTurn(playerCardId: null, oponentCardId: null),
        equals(MatchTurn(playerCardId: null, oponentCardId: null)),
      );

      expect(
        MatchTurn(playerCardId: null, oponentCardId: null),
        equals(
          isNot(
            MatchTurn(playerCardId: '1', oponentCardId: null),
          ),
        ),
      );

      expect(
        MatchTurn(playerCardId: null, oponentCardId: null),
        equals(
          isNot(
            MatchTurn(playerCardId: null, oponentCardId: '1'),
          ),
        ),
      );
    });
  });
}
