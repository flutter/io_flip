// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/draft/draft.dart';

class _MockGameResource extends Mock implements GameResource {}

void main() {
  group('DraftBloc', () {
    final cards = List.generate(
      10,
      (i) => Card(
        id: i.toString(),
        name: '',
        description: '',
        image: '',
        rarity: false,
        power: 20,
        suit: Suit.values[i % Suit.values.length],
      ),
    );

    late GameResource gameResource;

    setUp(() {
      gameResource = _MockGameResource();
      when(gameResource.generateCards).thenAnswer((_) async => cards);
    });

    test('has the correct initial state', () {
      expect(
        DraftBloc(gameResource: _MockGameResource()).state,
        equals(DraftState.initial()),
      );
    });

    blocTest<DraftBloc, DraftState>(
      'can request a deck',
      build: () => DraftBloc(gameResource: gameResource),
      act: (bloc) => bloc.add(DeckRequested()),
      expect: () => [
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.deckLoading,
          firstCardOpacity: 1,
        ),
        DraftState(
          cards: cards,
          selectedCards: const [],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'change the cards order on PreviousCard',
      build: () => DraftBloc(gameResource: gameResource),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(PreviousCard());
      },
      expect: () => [
        DraftState(
          cards: [
            cards.last,
            ...cards.getRange(0, cards.length - 1),
          ],
          selectedCards: const [],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'change the cards order on NextCard',
      build: () => DraftBloc(gameResource: gameResource),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(NextCard());
      },
      expect: () => [
        DraftState(
          cards: [
            ...cards.getRange(1, cards.length),
            cards.first,
          ],
          selectedCards: const [],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'change the cards order on CardSwiped',
      build: () => DraftBloc(gameResource: gameResource),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: .2,
      ),
      act: (bloc) {
        bloc.add(CardSwiped());
      },
      expect: () => [
        DraftState(
          cards: [
            ...cards.getRange(1, cards.length),
            cards.first,
          ],
          selectedCards: const [],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'changes opacity order on CardSwipeStarted',
      build: () => DraftBloc(gameResource: gameResource),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(CardSwipeStarted(.1));
      },
      expect: () => [
        DraftState(
          cards: cards,
          selectedCards: const [],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: .9,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'selects a card and changes deck on SelectCard',
      build: () => DraftBloc(gameResource: gameResource),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(SelectCard());
      },
      expect: () => [
        DraftState(
          cards: [
            ...cards.getRange(1, cards.length),
            cards.first,
          ],
          selectedCards: [cards.first],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'status is complete when the deck is full',
      build: () => DraftBloc(gameResource: gameResource),
      seed: () => DraftState(
        cards: cards,
        selectedCards: [cards[0], cards[1]],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(SelectCard());
      },
      expect: () => [
        DraftState(
          cards: cards,
          selectedCards: [cards[0], cards[1], cards.first],
          status: DraftStateStatus.deckSelected,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'emits failure when an error occured',
      setUp: () {
        when(gameResource.generateCards).thenThrow(Exception('Error'));
      },
      build: () => DraftBloc(gameResource: gameResource),
      act: (bloc) => bloc.add(DeckRequested()),
      expect: () => [
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.deckLoading,
          firstCardOpacity: 1,
        ),
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.deckFailed,
          firstCardOpacity: 1,
        ),
      ],
    );
  });
}
