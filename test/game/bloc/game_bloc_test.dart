// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart' as repo;
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/game/game.dart';
import 'package:web_socket_client/web_socket_client.dart';

class _MockGameResource extends Mock implements GameResource {}

class _MockWebSocket extends Mock implements WebSocket {}

class _MockMatchMakerRepository extends Mock
    implements repo.MatchMakerRepository {}

class _MockMatchSolver extends Mock implements MatchSolver {}

class _MockUser extends Mock implements User {
  @override
  String get id => 'mock-id';
}

void main() {
  group('GameBloc', () {
    final match = Match(
      id: 'matchId',
      hostDeck: Deck(id: '', userId: '', cards: const []),
      guestDeck: Deck(id: '', userId: '', cards: const []),
    );
    final matchState = MatchState(
      id: 'matchStateId',
      matchId: match.id,
      guestPlayedCards: const [],
      hostPlayedCards: const [],
      hostStartsMatch: true,
    );

    late StreamController<MatchState> matchStateController;
    late StreamController<repo.Match> matchController;
    late StreamController<ScoreCard> scoreController;
    late GameResource gameResource;
    late repo.MatchMakerRepository matchMakerRepository;
    late MatchSolver matchSolver;
    late User user;
    late WebSocket webSocket;
    const isHost = true;

    setUpAll(() {
      registerFallbackValue(match);
      registerFallbackValue(matchState);
    });

    setUp(() {
      webSocket = _MockWebSocket();
      matchSolver = _MockMatchSolver();
      gameResource = _MockGameResource();
      matchMakerRepository = _MockMatchMakerRepository();
      user = _MockUser();

      when(() => gameResource.getMatch(match.id))
          .thenAnswer((_) async => match);
      when(() => gameResource.getMatchState(match.id))
          .thenAnswer((_) async => matchState);

      matchStateController = StreamController();
      matchController = StreamController();
      scoreController = StreamController();

      when(() => matchMakerRepository.watchMatchState(any()))
          .thenAnswer((_) => matchStateController.stream);

      when(() => matchMakerRepository.watchScoreCard(any()))
          .thenAnswer((_) => scoreController.stream);

      when(() => matchMakerRepository.watchMatch(any()))
          .thenAnswer((_) => matchController.stream);

      when(() => matchMakerRepository.getScoreCard(any()))
          .thenAnswer((_) async => ScoreCard(id: 'scoreCardId'));
    });

    test('can be instantiated', () {
      expect(
        GameBloc(
          gameResource: _MockGameResource(),
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          matchConnection: webSocket,
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        GameBloc(
          gameResource: _MockGameResource(),
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: matchSolver,
          user: user,
          isHost: false,
          matchConnection: webSocket,
        ).state,
        equals(MatchLoadingState()),
      );
    });

    blocTest<GameBloc, GameState>(
      'loads a match',
      build: () => GameBloc(
        gameResource: gameResource,
        matchMakerRepository: matchMakerRepository,
        matchSolver: matchSolver,
        user: user,
        isHost: isHost,
        matchConnection: webSocket,
      ),
      act: (bloc) => bloc.add(MatchRequested(match.id)),
      expect: () => [
        MatchLoadingState(),
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match,
          matchState: matchState,
          turns: const [],
          playerPlayed: false,
          turnTimeRemaining: 10,
        ),
      ],
      verify: (_) {
        verify(() => gameResource.getMatch(match.id)).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'fails when the match is not found',
      build: () => GameBloc(
        gameResource: gameResource,
        matchMakerRepository: matchMakerRepository,
        matchSolver: matchSolver,
        user: user,
        isHost: isHost,
        matchConnection: webSocket,
      ),
      setUp: () {
        when(() => gameResource.getMatch(match.id))
            .thenAnswer((_) async => null);
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
        gameResource: gameResource,
        matchMakerRepository: matchMakerRepository,
        matchSolver: matchSolver,
        user: user,
        isHost: isHost,
        matchConnection: webSocket,
      ),
      setUp: () {
        when(() => gameResource.getMatch(match.id)).thenThrow(Exception('Ops'));
      },
      act: (bloc) => bloc.add(MatchRequested(match.id)),
      expect: () => [
        MatchLoadingState(),
        MatchLoadFailedState(),
      ],
    );

    group('register player and opponent moves', () {
      const baseState = MatchLoadedState(
        playerScoreCard: ScoreCard(id: 'scoreCardId'),
        match: Match(
          id: 'matchId',
          hostDeck: Deck(
            id: 'hostDeck',
            userId: 'hostUserId',
            cards: [
              Card(
                id: 'card1',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
                suit: Suit.air,
              ),
              Card(
                id: 'card2',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
                suit: Suit.air,
              ),
              Card(
                id: 'card3',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
                suit: Suit.air,
              ),
            ],
          ),
          guestDeck: Deck(
            id: 'guestDeck',
            userId: 'guestUserId',
            cards: [
              Card(
                id: 'card4',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
                suit: Suit.air,
              ),
              Card(
                id: 'card5',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
                suit: Suit.air,
              ),
              Card(
                id: 'card6',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
                suit: Suit.air,
              ),
            ],
          ),
        ),
        matchState: MatchState(
          id: 'matchStateId',
          matchId: 'matchId',
          hostPlayedCards: [],
          guestPlayedCards: [],
          hostStartsMatch: true,
        ),
        turns: [],
        playerPlayed: false,
        turnTimeRemaining: 10,
      );

      setUp(() {
        when(
          () => gameResource.playCard(
            matchId: 'matchId',
            cardId: any(named: 'cardId'),
            deckId: any(named: 'deckId'),
          ),
        ).thenAnswer((_) async {});
      });

      test('adds a new state change when the entity changes', () async {
        when(
          () => matchSolver.isPlayerTurn(any(), isHost: any(named: 'isHost')),
        ).thenReturn(true);
        final bloc = GameBloc(
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          matchConnection: webSocket,
        )..add(MatchRequested(baseState.match.id));

        await Future.microtask(() {});

        matchStateController.add(
          MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.matchId,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            guestPlayedCards: const ['card6'],
            hostStartsMatch: true,
          ),
        );

        await Future<void>.delayed(Duration(milliseconds: 20));

        final state = bloc.state;
        expect(state, isA<MatchLoadedState>());

        final matchLoadedState = state as MatchLoadedState;
        expect(
          matchLoadedState.turns,
          equals(
            [
              MatchTurn(
                playerCardId: null,
                opponentCardId: 'card6',
              ),
            ],
          ),
        );
      });

      test('adds a new state change when the score changes', () async {
        final bloc = GameBloc(
          user: User(id: 'userId'),
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          isHost: true,
          matchConnection: webSocket,
        )..add(MatchRequested(baseState.match.id));

        await Future.microtask(() {});

        scoreController.add(
          ScoreCard(id: 'scoreCardId', wins: 5),
        );

        await Future<void>.delayed(Duration(milliseconds: 20));

        final state = bloc.state;
        expect(state, isA<MatchLoadedState>());

        final matchLoadedState = state as MatchLoadedState;
        expect(
          matchLoadedState.playerScoreCard.wins,
          equals(5),
        );
      });

      blocTest<GameBloc, GameState>(
        'isPlayerTurn calls match solver correctly',
        build: () => GameBloc(
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          matchConnection: webSocket,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerTurn(baseState.matchState, isHost: true),
          ).thenReturn(true);
        },
        seed: () => baseState,
        act: (bloc) => bloc.isPlayerTurn,
        verify: (_) {
          verify(
            () => matchSolver.isPlayerTurn(baseState.matchState, isHost: true),
          ).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'canPlayerPlay calls match solver correctly',
        build: () => GameBloc(
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          matchConnection: webSocket,
        ),
        setUp: () {
          when(
            () => matchSolver.canPlayCard(
              baseState.matchState,
              any(),
              isHost: true,
            ),
          ).thenReturn(true);
        },
        seed: () => baseState,
        act: (bloc) => bloc.canPlayerPlay(''),
        verify: (_) {
          verify(
            () => matchSolver.canPlayCard(
              baseState.matchState,
              any(),
              isHost: true,
            ),
          ).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'isWinningCard return correctly when is host',
        build: () => GameBloc(
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          matchConnection: webSocket,
        ),
        setUp: () {
          when(() => matchSolver.calculateRoundResult(any(), any(), any()))
              .thenReturn(MatchResult.host);
        },
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: 'matchStateId',
            matchId: 'matchId',
            hostPlayedCards: const ['card1'],
            guestPlayedCards: const ['card6'],
            hostStartsMatch: true,
          ),
          turns: [
            MatchTurn(
              playerCardId: 'card1',
              opponentCardId: 'card6',
            ),
          ],
        ),
        verify: (bloc) {
          expect(
            bloc.isWiningCard(
              baseState.match.hostDeck.cards
                  .firstWhere((card) => card.id == 'card1'),
              isPlayer: true,
            ),
            isTrue,
          );
        },
      );

      blocTest<GameBloc, GameState>(
        'hasPlayerWon returns true if the host won, and the player is the host',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.id,
            guestPlayedCards: baseState.matchState.guestPlayedCards,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            hostStartsMatch: true,
            result: MatchResult.host,
          ),
        ),
        verify: (bloc) {
          expect(bloc.hasPlayerWon(), isTrue);
        },
      );

      blocTest<GameBloc, GameState>(
        'hasPlayerWon returns false if the guest won, and the player '
        'is the guest',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: false,
        ),
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.id,
            guestPlayedCards: baseState.matchState.guestPlayedCards,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            hostStartsMatch: true,
            result: MatchResult.guest,
          ),
        ),
        verify: (bloc) {
          expect(bloc.hasPlayerWon(), isTrue);
        },
      );

      blocTest<GameBloc, GameState>(
        'hasPlayerWon returns false if match is still loading',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          isHost: false,
          user: user,
        ),
        seed: () => const MatchLoadingState(),
        verify: (bloc) {
          expect(bloc.hasPlayerWon(), isFalse);
        },
      );

      blocTest<GameBloc, GameState>(
        'isWinningCard return correctly when is guest',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          isHost: false,
          user: user,
        ),
        setUp: () {
          when(() => matchSolver.calculateRoundResult(any(), any(), any()))
              .thenReturn(MatchResult.guest);
        },
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: 'matchStateId',
            matchId: 'matchId',
            hostPlayedCards: const ['card1'],
            guestPlayedCards: const ['card6'],
            hostStartsMatch: true,
          ),
          turns: [
            MatchTurn(
              playerCardId: 'card6',
              opponentCardId: 'card1',
            ),
          ],
        ),
        verify: (bloc) {
          expect(
            bloc.isWiningCard(
              baseState.match.guestDeck.cards
                  .firstWhere((card) => card.id == 'card6'),
              isPlayer: true,
            ),
            isTrue,
          );
        },
      );

      blocTest<GameBloc, GameState>(
        'plays a player card',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        seed: () => baseState,
        act: (bloc) => bloc.add(PlayerPlayed('new_card_1')),
        expect: () => [
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
            ),
            turns: const [],
            playerPlayed: true,
            turnTimeRemaining: 10,
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays a player card when being the guest',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: false,
        ),
        seed: () => baseState,
        act: (bloc) => bloc.add(PlayerPlayed('new_card_1')),
        expect: () => [
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
            ),
            turns: const [],
            playerPlayed: true,
            turnTimeRemaining: 10,
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'marks the playerPlayed as false on receive the new state',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerTurn(any(), isHost: any(named: 'isHost')),
          ).thenReturn(true);
        },
        seed: () => baseState,
        act: (bloc) {
          bloc
            ..add(PlayerPlayed('new_card_1'))
            ..add(
              MatchStateUpdated(
                MatchState(
                  id: baseState.matchState.id,
                  matchId: baseState.matchState.matchId,
                  hostPlayedCards: const ['new_card_1'],
                  guestPlayedCards: baseState.matchState.guestPlayedCards,
                  hostStartsMatch: true,
                ),
              ),
            );
        },
        expect: () => [
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
            ),
            turns: const [],
            playerPlayed: true,
            turnTimeRemaining: 10,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const ['new_card_1'],
              hostStartsMatch: true,
            ),
            turns: const [
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
            playerPlayed: false,
            turnTimeRemaining: 10,
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'marks the playerPlayed as false on receive the new state when being '
        'the guest',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: false,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerTurn(any(), isHost: any(named: 'isHost')),
          ).thenReturn(true);
        },
        seed: () => baseState,
        act: (bloc) {
          bloc
            ..add(PlayerPlayed('new_card_1'))
            ..add(
              MatchStateUpdated(
                MatchState(
                  id: baseState.matchState.id,
                  matchId: baseState.matchState.matchId,
                  hostPlayedCards: baseState.matchState.hostPlayedCards,
                  guestPlayedCards: const ['new_card_1'],
                  hostStartsMatch: true,
                ),
              ),
            );
        },
        expect: () => [
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
            ),
            turns: const [],
            playerPlayed: true,
            turnTimeRemaining: 10,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const ['new_card_1'],
              hostPlayedCards: const [],
              hostStartsMatch: true,
            ),
            turns: const [
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
            playerPlayed: false,
            turnTimeRemaining: 10,
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays a player card, receives confirmation and then receives an '
        'opponent card',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerTurn(any(), isHost: any(named: 'isHost')),
          ).thenReturn(true);
        },
        seed: () => baseState,
        act: (bloc) {
          bloc
            ..add(PlayerPlayed('new_card_1'))
            ..add(
              MatchStateUpdated(
                MatchState(
                  id: baseState.matchState.id,
                  matchId: baseState.matchState.matchId,
                  hostPlayedCards: const ['new_card_1'],
                  guestPlayedCards: baseState.matchState.guestPlayedCards,
                  hostStartsMatch: true,
                ),
              ),
            )
            ..add(
              MatchStateUpdated(
                MatchState(
                  id: baseState.matchState.id,
                  matchId: baseState.matchState.matchId,
                  hostPlayedCards: const ['new_card_1'],
                  guestPlayedCards: const ['new_card_2'],
                  hostStartsMatch: true,
                ),
              ),
            );
        },
        expect: () => [
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
            ),
            turns: const [],
            playerPlayed: true,
            turnTimeRemaining: 10,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const ['new_card_1'],
              hostStartsMatch: true,
            ),
            turns: const [
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
            playerPlayed: false,
            turnTimeRemaining: 10,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const ['new_card_2'],
              hostPlayedCards: const ['new_card_1'],
              hostStartsMatch: true,
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
            ],
            playerPlayed: false,
            turnTimeRemaining: 10,
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays a player card and opponent card and another opponent one',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerTurn(any(), isHost: any(named: 'isHost')),
          ).thenReturn(true);
        },
        seed: () => baseState,
        act: (bloc) {
          bloc
            ..add(PlayerPlayed('new_card_1'))
            ..add(
              MatchStateUpdated(
                MatchState(
                  id: baseState.matchState.id,
                  matchId: baseState.matchState.matchId,
                  hostPlayedCards: const ['new_card_1'],
                  guestPlayedCards: baseState.matchState.guestPlayedCards,
                  hostStartsMatch: true,
                ),
              ),
            )
            ..add(
              MatchStateUpdated(
                MatchState(
                  id: baseState.matchState.id,
                  matchId: baseState.matchState.matchId,
                  hostPlayedCards: const ['new_card_1'],
                  guestPlayedCards: const ['new_card_2'],
                  hostStartsMatch: true,
                ),
              ),
            )
            ..add(
              MatchStateUpdated(
                MatchState(
                  id: baseState.matchState.id,
                  matchId: baseState.matchState.matchId,
                  hostPlayedCards: const ['new_card_1'],
                  guestPlayedCards: const ['new_card_2', 'new_card_3'],
                  hostStartsMatch: true,
                ),
              ),
            );
        },
        expect: () => [
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
            ),
            turns: const [],
            playerPlayed: true,
            turnTimeRemaining: 10,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const ['new_card_1'],
              hostStartsMatch: true,
            ),
            turns: const [
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
            playerPlayed: false,
            turnTimeRemaining: 10,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const ['new_card_2'],
              hostPlayedCards: const ['new_card_1'],
              hostStartsMatch: true,
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
            ],
            playerPlayed: false,
            turnTimeRemaining: 10,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const ['new_card_2', 'new_card_3'],
              hostPlayedCards: const ['new_card_1'],
              hostStartsMatch: true,
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
              MatchTurn(
                opponentCardId: 'new_card_3',
                playerCardId: null,
              ),
            ],
            playerPlayed: false,
            turnTimeRemaining: 10,
          ),
        ],
      );

      group('- turn countdown', () {
        test('starts correctly', () {
          fakeAsync((async) {
            when(
              () =>
                  matchSolver.isPlayerTurn(any(), isHost: any(named: 'isHost')),
            ).thenReturn(true);

            final bloc = GameBloc(
              matchConnection: webSocket,
              gameResource: gameResource,
              matchMakerRepository: matchMakerRepository,
              matchSolver: matchSolver,
              user: user,
              isHost: true,
            )
              ..add(MatchRequested(match.id))
              ..add(MatchStateUpdated(baseState.matchState));

            async.elapse(Duration(milliseconds: 2500));

            expect(
              bloc.state,
              equals(
                MatchLoadedState(
                  playerScoreCard: ScoreCard(id: 'scoreCardId'),
                  match: match,
                  matchState: matchState,
                  turns: const [],
                  playerPlayed: false,
                  turnTimeRemaining: 8,
                ),
              ),
            );
          });
        });

        test('ends and plays card automatically for host', () {
          fakeAsync((async) {
            when(
              () =>
                  matchSolver.isPlayerTurn(any(), isHost: any(named: 'isHost')),
            ).thenReturn(true);
            when(() => gameResource.getMatch(any())).thenAnswer((_) async {
              return baseState.match;
            });

            GameBloc(
              matchConnection: webSocket,
              gameResource: gameResource,
              matchMakerRepository: matchMakerRepository,
              matchSolver: matchSolver,
              user: user,
              isHost: true,
            )
              ..add(MatchRequested(baseState.match.id))
              ..add(MatchStateUpdated(baseState.matchState));

            async.elapse(Duration(milliseconds: 10500));

            verify(
              () => gameResource.playCard(
                matchId: any(named: 'matchId'),
                cardId: any(named: 'cardId'),
                deckId: any(named: 'deckId'),
              ),
            ).called(1);
          });
        });

        test('ends and plays card automatically for guest', () {
          fakeAsync((async) {
            when(
              () =>
                  matchSolver.isPlayerTurn(any(), isHost: any(named: 'isHost')),
            ).thenReturn(true);
            when(() => gameResource.getMatch(any())).thenAnswer((_) async {
              return baseState.match;
            });

            GameBloc(
              matchConnection: webSocket,
              gameResource: gameResource,
              matchMakerRepository: matchMakerRepository,
              matchSolver: matchSolver,
              user: user,
              isHost: false,
            )
              ..add(MatchRequested(baseState.match.id))
              ..add(MatchStateUpdated(baseState.matchState));

            async.elapse(Duration(milliseconds: 10500));

            verify(
              () => gameResource.playCard(
                matchId: any(named: 'matchId'),
                cardId: any(named: 'cardId'),
                deckId: any(named: 'deckId'),
              ),
            ).called(1);
          });
        });
      });
    });

    group('MatchLoadedState', () {
      group('isCardTurnComplete', () {
        final match1 = Match(
          id: 'match1',
          hostDeck: Deck(id: '', userId: '', cards: const []),
          guestDeck: Deck(id: '', userId: '', cards: const []),
        );
        final matchState1 = MatchState(
          id: 'matchState1',
          matchId: match1.id,
          hostPlayedCards: const [],
          guestPlayedCards: const [],
          hostStartsMatch: true,
        );
        final card = Card(
          id: '1',
          name: '',
          description: '',
          image: '',
          power: 10,
          rarity: false,
          suit: Suit.air,
        );

        final baseState = MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match1,
          matchState: matchState1,
          turns: const [],
          playerPlayed: false,
          turnTimeRemaining: 10,
        );

        test('returns true if the card is the winning one', () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(
                opponentCardId: card.id,
                playerCardId: 'a',
              ),
            ],
          );

          expect(state.isCardTurnComplete(card), isTrue);
        });

        test('returns false if the turn is not complete', () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(
                opponentCardId: card.id,
                playerCardId: null,
              ),
            ],
          );

          expect(state.isCardTurnComplete(card), isFalse);
        });

        test('can detect the card turn no matter the order', () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(
                opponentCardId: 'a',
                playerCardId: card.id,
              ),
              MatchTurn(
                opponentCardId: 'b',
                playerCardId: null,
              ),
            ],
          );

          expect(state.isCardTurnComplete(card), isTrue);
        });
      });
    });

    group('MatchTurn', () {
      test('isComplete', () {
        expect(
          MatchTurn(playerCardId: null, opponentCardId: null).isComplete(),
          isFalse,
        );

        expect(
          MatchTurn(playerCardId: 'a', opponentCardId: null).isComplete(),
          isFalse,
        );

        expect(
          MatchTurn(playerCardId: null, opponentCardId: 'a').isComplete(),
          isFalse,
        );

        expect(
          MatchTurn(playerCardId: 'b', opponentCardId: 'a').isComplete(),
          isTrue,
        );
      });
    });

    group('manage player presence', () {
      blocTest<GameBloc, GameState>(
        'notifies when opponent(guest) is absent',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        act: (bloc) {
          bloc.add(ManagePlayerPresence(match.id));
          matchController.add(
            repo.Match(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
              hostConnected: true,
            ),
          );
        },
        expect: () => [OpponentAbsentState()],
        verify: (_) {
          verify(() => matchMakerRepository.watchMatch(match.id)).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'notifies when opponent(host) is absent',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: false,
          matchSolver: matchSolver,
        ),
        act: (bloc) {
          bloc.add(ManagePlayerPresence(match.id));
          matchController.add(
            repo.Match(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
              guestConnected: true,
            ),
          );
        },
        expect: () => [OpponentAbsentState()],
        verify: (_) {
          verify(() => matchMakerRepository.watchMatch(match.id)).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'does not return a state if opponent is present',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        act: (bloc) {
          bloc.add(ManagePlayerPresence(match.id));
          matchController.add(
            repo.Match(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
              hostConnected: true,
              guestConnected: true,
            ),
          );
        },
        expect: () => <GameState>[],
        verify: (_) {
          verify(() => matchMakerRepository.watchMatch(match.id)).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'fails when fetching the match throws an exception',
        build: () => GameBloc(
          matchConnection: webSocket,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        setUp: () {
          when(() => matchMakerRepository.watchMatch(any())).thenThrow(
            Exception('Ops'),
          );
        },
        act: (bloc) {
          bloc.add(ManagePlayerPresence(match.id));
          matchController.add(
            repo.Match(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
            ),
          );
        },
        expect: () => [ManagePlayerPresenceFailedState()],
        verify: (_) {
          verify(() => matchMakerRepository.watchMatch(match.id)).called(1);
        },
      );
    });
  });
}
