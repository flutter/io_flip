// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('MatchSolver', () {
    group('calculateMatchResult', () {
      final cards = List.generate(
        6,
        (i) => Card(
          id: 'card_$i',
          description: '',
          name: '',
          image: '',
          rarity: false,
          power: 1 + i,
        ),
      );

      test("throws MatchResolutionFailure when the match isn't over yet", () {
        final match = Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        );
        final state = MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: [cards[4].id, cards[2].id, cards[0].id],
          guestPlayedCards: [cards[3].id, cards[1].id],
        );

        expect(
          () => MatchSolver().calculateMatchResult(
            match,
            state,
          ),
          throwsA(isA<MatchResolutionFailure>()),
        );
      });

      test('return host when the host has won', () {
        final match = Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        );
        final state = MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: [cards[4].id, cards[2].id, cards[0].id],
          guestPlayedCards: [cards[3].id, cards[1].id, cards[5].id],
        );

        final matchResult = MatchSolver().calculateMatchResult(
          match,
          state,
        );
        expect(matchResult, equals(MatchResult.host));
      });

      test('return guest when the guest has won', () {
        final match = Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        );
        final state = MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: [cards[0].id, cards[2].id, cards[4].id],
          guestPlayedCards: [cards[3].id, cards[1].id, cards[5].id],
        );

        final matchResult = MatchSolver().calculateMatchResult(
          match,
          state,
        );
        expect(matchResult, equals(MatchResult.guest));
      });

      test('returns draw when match is draw', () {
        final cards = List.generate(
          6,
          (i) => Card(
            id: 'card_$i',
            description: '',
            name: '',
            image: '',
            rarity: false,
            power: 1,
          ),
        );

        final match = Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        );
        final state = MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: [cards[0].id, cards[2].id, cards[4].id],
          guestPlayedCards: [cards[3].id, cards[1].id, cards[5].id],
        );

        final matchResult = MatchSolver().calculateMatchResult(
          match,
          state,
        );
        expect(matchResult, equals(MatchResult.draw));
      });
    });

    group('calculateRoundResult', () {
      final cards = List.generate(
        6,
        (i) => Card(
          id: 'card_$i',
          description: '',
          name: '',
          image: '',
          rarity: false,
          power: 1 + i,
        ),
      );

      test("throws MatchResolutionFailure when the round isn't over yet", () {
        final match = Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        );
        final state = MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: [cards[4].id, cards[2].id, cards[0].id],
          guestPlayedCards: [cards[3].id, cards[1].id],
        );

        expect(
          () => MatchSolver().calculateRoundResult(
            match,
            state,
            2,
          ),
          throwsA(isA<MatchResolutionFailure>()),
        );
      });

      test('return host when the host has won', () {
        final match = Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        );
        final state = MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: [cards[4].id, cards[2].id, cards[0].id],
          guestPlayedCards: [cards[3].id, cards[1].id, cards[5].id],
        );

        final matchResult = MatchSolver().calculateRoundResult(
          match,
          state,
          1,
        );
        expect(matchResult, equals(MatchResult.host));
      });

      test('return guest when the guest has won', () {
        final match = Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        );
        final state = MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: [cards[0].id, cards[2].id, cards[4].id],
          guestPlayedCards: [cards[3].id, cards[1].id, cards[5].id],
        );

        final matchResult = MatchSolver().calculateRoundResult(
          match,
          state,
          2,
        );
        expect(matchResult, equals(MatchResult.guest));
      });

      test('returns draw when match is draw', () {
        final cards = List.generate(
          6,
          (i) => Card(
            id: 'card_$i',
            description: '',
            name: '',
            image: '',
            rarity: false,
            power: 1,
          ),
        );

        final match = Match(
          id: '',
          hostDeck: Deck(
            id: '',
            cards: [cards[0], cards[2], cards[4]],
          ),
          guestDeck: Deck(
            id: '',
            cards: [cards[1], cards[3], cards[5]],
          ),
        );
        final state = MatchState(
          id: '',
          matchId: '',
          hostPlayedCards: [cards[0].id, cards[2].id, cards[4].id],
          guestPlayedCards: [cards[3].id, cards[1].id, cards[5].id],
        );

        final matchResult = MatchSolver().calculateRoundResult(
          match,
          state,
          0,
        );
        expect(matchResult, equals(MatchResult.draw));
      });
    });

    group('canPlayCard', () {
      group('when is the host', () {
        const isHost = true;

        test('returns true when nobody has played yet', () {
          final matchState = MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [],
            guestPlayedCards: const [],
          );

          expect(
            MatchSolver().canPlayCard(matchState, isHost: isHost),
            isTrue,
          );
        });

        test('returns true when guest played, but host not', () {
          final matchState = MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [],
            guestPlayedCards: const [''],
          );

          expect(
            MatchSolver().canPlayCard(matchState, isHost: isHost),
            isTrue,
          );
        });

        test('returns false when host has played but guest not', () {
          final matchState = MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const ['', ''],
            guestPlayedCards: const [''],
          );

          expect(
            MatchSolver().canPlayCard(matchState, isHost: isHost),
            isFalse,
          );
        });
      });

      group('when is the guest', () {
        const isHost = false;

        test('returns true when nobody has played yet', () {
          final matchState = MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [],
            guestPlayedCards: const [],
          );

          expect(
            MatchSolver().canPlayCard(matchState, isHost: isHost),
            isTrue,
          );
        });

        test('returns true when host played, but guest not', () {
          final matchState = MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [''],
            guestPlayedCards: const [],
          );

          expect(
            MatchSolver().canPlayCard(matchState, isHost: isHost),
            isTrue,
          );
        });

        test('returns false when guest has played but host not', () {
          final matchState = MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [''],
            guestPlayedCards: const ['', ''],
          );

          expect(
            MatchSolver().canPlayCard(matchState, isHost: isHost),
            isFalse,
          );
        });
      });
    });
  });
}
