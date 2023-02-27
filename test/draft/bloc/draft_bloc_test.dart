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
    const card = Card(
      id: '1',
      name: '',
      description: '',
      rarity: true,
      image: '',
      power: 1,
    );

    late GameClient gameClient;

    setUp(() {
      gameClient = _MockGameClient();
      when(gameClient.generateCard).thenAnswer((_) async => card);
    });

    test('has the correct initial state', () {
      expect(
        DraftBloc(gameClient: _MockGameClient()).state,
        equals(DraftState.initial()),
      );
    });

    blocTest<DraftBloc, DraftState>(
      'can request a card',
      build: () => DraftBloc(gameClient: gameClient),
      act: (bloc) => bloc.add(CardRequested()),
      expect: () => [
        DraftState(
          cards: const [],
          status: DraftStateStatus.cardLoading,
        ),
        DraftState(
          cards: const [card],
          status: DraftStateStatus.cardLoaded,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'status is complete when the deck is full',
      build: () => DraftBloc(gameClient: gameClient),
      seed: () => DraftState(
        cards: const [card, card],
        status: DraftStateStatus.cardLoaded,
      ),
      act: (bloc) => bloc.add(CardRequested()),
      expect: () => [
        DraftState(
          cards: const [card, card],
          status: DraftStateStatus.cardLoading,
        ),
        DraftState(
          cards: const [card, card, card],
          status: DraftStateStatus.deckCompleted,
        ),
      ],
    );

    blocTest<DraftBloc, DraftState>(
      'emits failure when an error occured',
      setUp: () {
        when(gameClient.generateCard).thenThrow(Exception('Error'));
      },
      build: () => DraftBloc(gameClient: gameClient),
      act: (bloc) => bloc.add(CardRequested()),
      expect: () => [
        DraftState(
          cards: const [],
          status: DraftStateStatus.cardLoading,
        ),
        DraftState(
          cards: const [],
          status: DraftStateStatus.cardFailed,
        ),
      ],
    );
  });
}
