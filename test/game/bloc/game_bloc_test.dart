// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart' hide Match;
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/game/game.dart';

class _MockGameClient extends Mock implements GameClient {}

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

void main() {
  group('GameBloc', () {
    final match = Match(
      id: 'matchId',
      hostDeck: Deck(id: '', cards: const []),
      guestDeck: Deck(id: '', cards: const []),
    );
    final matchState = MatchState(
      id: 'matchStateId',
      matchId: match.id,
      guestPlayedCards: const [],
      hostPlayedCards: const [],
    );

    late StreamController<String> guestController;
    late StreamController<String> hostController;
    late GameClient gameClient;
    late MatchMakerRepository matchMakerRepository;
    const isHost = true;

    setUp(() {
      gameClient = _MockGameClient();
      matchMakerRepository = _MockMatchMakerRepository();

      when(() => gameClient.getMatch(match.id)).thenAnswer((_) async => match);
      when(() => gameClient.getMatchState(match.id))
          .thenAnswer((_) async => matchState);

      guestController = StreamController();
      hostController = StreamController();

      when(() => matchMakerRepository.watchGuestCards(any()))
          .thenAnswer((_) => guestController.stream);

      when(() => matchMakerRepository.watchHostCards(any()))
          .thenAnswer((_) => hostController.stream);
    });

    test('can be instantiated', () {
      expect(
        GameBloc(
          gameClient: _MockGameClient(),
          matchMakerRepository: _MockMatchMakerRepository(),
          isHost: true,
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        GameBloc(
          gameClient: _MockGameClient(),
          matchMakerRepository: _MockMatchMakerRepository(),
          isHost: false,
        ).state,
        equals(MatchLoadingState()),
      );
    });

    blocTest<GameBloc, GameState>(
      'loads a match',
      build: () => GameBloc(
        gameClient: gameClient,
        matchMakerRepository: matchMakerRepository,
        isHost: isHost,
      ),
      setUp: () {},
      act: (bloc) => bloc.add(MatchRequested(match.id)),
      expect: () => [
        MatchLoadingState(),
        MatchLoadedState(
          match: match,
          matchState: matchState,
          turns: const [],
        ),
      ],
      verify: (_) {
        verify(() => gameClient.getMatch(match.id)).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'fails when the match is not found',
      build: () => GameBloc(
        gameClient: gameClient,
        matchMakerRepository: matchMakerRepository,
        isHost: isHost,
      ),
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
      'fails when fetching the match throws an exception',
      build: () => GameBloc(
        gameClient: gameClient,
        matchMakerRepository: matchMakerRepository,
        isHost: isHost,
      ),
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
