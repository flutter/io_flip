// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/draft/draft.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:mocktail/mocktail.dart';

class _MockGameResource extends Mock implements GameResource {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  group('DraftBloc', () {
    final rareCard = Card(
      id: '0',
      name: '',
      description: '',
      image: '',
      rarity: true,
      power: 20,
      suit: Suit.fire,
    );

    final commonCard = Card(
      id: '0',
      name: '',
      description: '',
      image: '',
      rarity: false,
      power: 20,
      suit: Suit.fire,
    );

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

    final deck = Deck(
      id: 'deckId',
      userId: 'userId',
      cards: cards.sublist(0, 3),
    );

    late GameResource gameResource;
    late AudioController audioController;

    setUp(() {
      gameResource = _MockGameResource();
      when(() => gameResource.generateCards(Prompt()))
          .thenAnswer((_) async => cards);

      audioController = _MockAudioController();
      when(() => audioController.playSfx(any())).thenAnswer((_) {});
    });

    test('has the correct initial state', () {
      expect(
        DraftBloc(
          gameResource: _MockGameResource(),
          audioController: _MockAudioController(),
        ).state,
        equals(DraftState.initial()),
      );
    });

    blocTest<DraftBloc, DraftState>(
      'can request a deck',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      act: (bloc) => bloc.add(DeckRequested(Prompt())),
      expect: () => [
        DraftState(
          cards: const [],
          selectedCards: const [null, null, null],
          status: DraftStateStatus.deckLoading,
          firstCardOpacity: 1,
        ),
        DraftState(
          cards: cards,
          selectedCards: const [null, null, null],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'plays the holo reveal sfx when the deck is loaded and the first '
      'card is rare',
      setUp: () {
        final cards = List.generate(
          10,
          (i) => Card(
            id: i.toString(),
            name: '',
            description: '',
            image: '',
            rarity: i == 0,
            power: 20,
            suit: Suit.values[i % Suit.values.length],
          ),
        );
        when(() => gameResource.generateCards(Prompt()))
            .thenAnswer((_) async => cards);
      },
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      act: (bloc) => bloc.add(DeckRequested(Prompt())),
      verify: (_) {
        verify(() => audioController.playSfx(Assets.sfx.holoReveal)).called(1);
      },
    );

    blocTest<DraftBloc, DraftState>(
      'change the cards order on PreviousCard',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [null, null, null],
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
          selectedCards: const [null, null, null],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'plays the holo reveal when the previous card is rare',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: [commonCard, rareCard],
        selectedCards: const [null, null, null],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(PreviousCard());
      },
      verify: (_) {
        verify(() => audioController.playSfx(Assets.sfx.holoReveal)).called(1);
      },
    );

    blocTest<DraftBloc, DraftState>(
      'change the cards order on NextCard',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [null, null, null],
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
          selectedCards: const [null, null, null],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'plays the holo reveal when the next card is rare',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: [commonCard, rareCard],
        selectedCards: const [null, null, null],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(NextCard());
      },
      verify: (_) {
        verify(() => audioController.playSfx(Assets.sfx.holoReveal)).called(1);
      },
    );

    blocTest<DraftBloc, DraftState>(
      'change the cards order on CardSwiped',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [null, null, null],
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
          selectedCards: const [null, null, null],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
    );
    blocTest<DraftBloc, DraftState>(
      'plays the holo reveal after a swipe and when the next card is rare',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: [commonCard, rareCard],
        selectedCards: const [null, null, null],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(CardSwiped());
      },
      verify: (_) {
        verify(() => audioController.playSfx(Assets.sfx.holoReveal)).called(1);
      },
    );

    blocTest<DraftBloc, DraftState>(
      'changes opacity order on CardSwipeStarted',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [null, null, null],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(CardSwipeStarted(.1));
      },
      expect: () => [
        DraftState(
          cards: cards,
          selectedCards: const [null, null, null],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: .9,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'plays cardMovement on CardSwipeStarted',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [null, null, null],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(CardSwipeStarted(.1));
      },
      verify: (_) {
        verify(() => audioController.playSfx(Assets.sfx.cardMovement))
            .called(1);
      },
    );

    blocTest<DraftBloc, DraftState>(
      'selects a card, changes deck on SelectCard, and plays sfx',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: cards,
        selectedCards: const [null, null, null],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(SelectCard(0));
      },
      expect: () => [
        DraftState(
          cards: [
            ...cards.getRange(1, cards.length),
          ],
          selectedCards: [cards.first, null, null],
          status: DraftStateStatus.deckLoaded,
          firstCardOpacity: 1,
        ),
      ],
      verify: (_) {
        final captured =
            verify(() => audioController.playSfx(captureAny())).captured;
        final sfx = captured.first;
        expect(sfx, isA<String>());
        expect(sfx as String, Assets.sfx.addToHand);
      },
    );

    blocTest<DraftBloc, DraftState>(
      'can still select a card when the deck is full',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: cards,
        selectedCards: [cards[1], cards[2], cards[3]],
        status: DraftStateStatus.deckSelected,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(SelectCard(2));
      },
      expect: () => [
        DraftState(
          cards: [
            ...cards.getRange(1, cards.length),
            cards[3],
          ],
          selectedCards: [cards[1], cards[2], cards.first],
          status: DraftStateStatus.deckSelected,
          firstCardOpacity: 1,
        ),
      ],
      verify: (_) {
        final captured =
            verify(() => audioController.playSfx(captureAny())).captured;
        final sfx = captured.first;
        expect(sfx, isA<String>());
        expect(sfx as String, Assets.sfx.addToHand);
      },
    );

    blocTest<DraftBloc, DraftState>(
      'status is complete when the deck is full',
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      seed: () => DraftState(
        cards: cards,
        selectedCards: [cards[2], null, cards[3]],
        status: DraftStateStatus.deckLoaded,
        firstCardOpacity: 1,
      ),
      act: (bloc) {
        bloc.add(SelectCard(1));
      },
      expect: () => [
        DraftState(
          cards: [
            ...cards.getRange(1, cards.length),
          ],
          selectedCards: [cards[2], cards.first, cards[3]],
          status: DraftStateStatus.deckSelected,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'emits failure when an error occured',
      setUp: () {
        when(() => gameResource.generateCards(Prompt()))
            .thenThrow(Exception('Error'));
      },
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      act: (bloc) => bloc.add(DeckRequested(Prompt())),
      expect: () => [
        DraftState(
          cards: const [],
          selectedCards: const [null, null, null],
          status: DraftStateStatus.deckLoading,
          firstCardOpacity: 1,
        ),
        DraftState(
          cards: const [],
          selectedCards: const [null, null, null],
          status: DraftStateStatus.deckFailed,
          firstCardOpacity: 1,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'emits player deck created when requested',
      setUp: () {
        when(() => gameResource.createDeck(any()))
            .thenAnswer((_) async => 'deckId');
        when(() => gameResource.getDeck(any())).thenAnswer((_) async => deck);
      },
      seed: () => DraftState(
        cards: cards,
        selectedCards: [cards[0], cards[1], cards[2]],
        status: DraftStateStatus.deckSelected,
        firstCardOpacity: 1,
      ),
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      act: (bloc) => bloc.add(
        PlayerDeckRequested([cards[0].id, cards[1].id, cards[2].id]),
      ),
      expect: () => [
        DraftState(
          cards: cards,
          selectedCards: [cards[0], cards[1], cards[2]],
          status: DraftStateStatus.deckLoading,
          firstCardOpacity: 1,
        ),
        DraftState(
          cards: cards,
          selectedCards: [cards[0], cards[1], cards[2]],
          status: DraftStateStatus.playerDeckCreated,
          firstCardOpacity: 1,
          deck: deck,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'emits player deck failed when request fails',
      setUp: () {
        when(() => gameResource.createDeck(any())).thenThrow(Exception());
      },
      seed: () => DraftState(
        cards: cards,
        selectedCards: [cards[0], cards[1], cards[2]],
        status: DraftStateStatus.deckSelected,
        firstCardOpacity: 1,
      ),
      build: () => DraftBloc(
        gameResource: gameResource,
        audioController: audioController,
      ),
      act: (bloc) => bloc.add(
        PlayerDeckRequested([cards[0].id, cards[1].id, cards[2].id]),
      ),
      expect: () => [
        DraftState(
          cards: cards,
          selectedCards: [cards[0], cards[1], cards[2]],
          status: DraftStateStatus.deckLoading,
          firstCardOpacity: 1,
        ),
        DraftState(
          cards: cards,
          selectedCards: [cards[0], cards[1], cards[2]],
          status: DraftStateStatus.playerDeckFailed,
          firstCardOpacity: 1,
        ),
      ],
    );
  });
}
