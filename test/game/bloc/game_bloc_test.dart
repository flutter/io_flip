// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/game/game.dart';

class _MockGameClient extends Mock implements GameClient {}

void main() {
  group('GameBloc', () {
    final match = Match(
      id: 'matchId',
      hostDeck: Deck(id: '', cards: const []),
      guestDeck: Deck(id: '', cards: const []),
    );

    late GameClient gameClient;

    setUp(() {
      gameClient = _MockGameClient();
    });

    test('can be instantiated', () {
      expect(
        GameBloc(gameClient: _MockGameClient()),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        GameBloc(gameClient: _MockGameClient()).state,
        equals(MatchLoadingState()),
      );
    });

    blocTest<GameBloc, GameState>(
      'loads a match',
      build: () => GameBloc(gameClient: gameClient),
      setUp: () {
        when(() => gameClient.getMatch(match.id))
            .thenAnswer((_) async => match);
      },
      act: (bloc) => bloc.add(MatchRequested(match.id)),
      expect: () => [
        MatchLoadingState(),
        MatchLoadedState(match),
      ],
    );

    blocTest<GameBloc, GameState>(
      'fails when the match is not found',
      build: () => GameBloc(gameClient: gameClient),
      setUp: () {
        when(() => gameClient.getMatch(match.id)).thenAnswer((_) async => null);
      },
      act: (bloc) => bloc.add(MatchRequested(match.id)),
      expect: () => [
        MatchLoadingState(),
        MatchLoadFailedState(),
      ],
    );

    blocTest<GameBloc, GameState>(
      'fails when the match is not found',
      build: () => GameBloc(gameClient: gameClient),
      setUp: () {
        when(() => gameClient.getMatch(match.id)).thenThrow(Exception('Ops'));
      },
      act: (bloc) => bloc.add(MatchRequested(match.id)),
      expect: () => [
        MatchLoadingState(),
        MatchLoadFailedState(),
      ],
    );
  });
}
