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
  });
}
