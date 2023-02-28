// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/draft/draft.dart';

class _MockGameClient extends Mock implements GameClient {}

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
      ),
    );

    late GameClient gameClient;

    setUp(() {
      gameClient = _MockGameClient();
      var last = 0;
      when(gameClient.generateCard).thenAnswer((_) async => cards[last++]);
    });

    test('has the correct initial state', () {
      expect(
        DraftBloc(gameClient: _MockGameClient()).state,
        equals(DraftState.initial()),
      );
    });

    blocTest<DraftBloc, DraftState>(
      'can request a deck',
      build: () => DraftBloc(gameClient: gameClient),
      act: (bloc) => bloc.add(DeckRequested()),
      expect: () => [
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.deckLoading,
        ),
        DraftState(
          cards: cards,
          selectedCards: const [],
          status: DraftStateStatus.deckLoaded,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'change the cards order on NextCard',
      build: () => DraftBloc(gameClient: gameClient),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [],
        status: DraftStateStatus.deckLoaded,
      ),
      act: (bloc) {
        bloc.add(NextCard());
      },
      expect: () => [
        DraftState(
          cards: [
            cards.last,
            ...List.generate(9, (i) => cards[i]),
          ],
          selectedCards: const [],
          status: DraftStateStatus.deckLoaded,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'status is complete when the deck is full',
      build: () => DraftBloc(gameClient: gameClient),
      seed: () => DraftState(
        cards: cards,
        selectedCards: [cards[0], cards[1]],
        status: DraftStateStatus.deckLoaded,
      ),
      act: (bloc) {
        bloc.add(SelectCard());
      },
      expect: () => [
        DraftState(
          cards: cards,
          selectedCards: [cards[0], cards[1], cards.last],
          status: DraftStateStatus.deckSelected,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'emits failure when an error occured',
      setUp: () {
        when(gameClient.generateCard).thenThrow(Exception('Error'));
      },
      build: () => DraftBloc(gameClient: gameClient),
      act: (bloc) => bloc.add(DeckRequested()),
      expect: () => [
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.deckLoading,
        ),
        DraftState(
          cards: const [],
          selectedCards: const [],
          status: DraftStateStatus.deckFailed,
        ),
      ],
    );
  });
}
