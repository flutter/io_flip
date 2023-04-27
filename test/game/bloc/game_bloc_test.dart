// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class _MockGameResource extends Mock implements GameResource {}

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockAudioController extends Mock implements AudioController {}

class _MockMatchSolver extends Mock implements MatchSolver {}

class _MockUser extends Mock implements User {
  @override
  String get id => 'mock-id';
}

class _MockTimer extends Mock implements Timer {}

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
    );

    late StreamController<MatchState> matchStateController;
    late StreamController<DraftMatch> matchController;
    late StreamController<ScoreCard> scoreController;
    late GameResource gameResource;
    late MatchMakerRepository matchMakerRepository;
    late MatchSolver matchSolver;
    late AudioController audioController;
    late User user;
    late ConnectionRepository connectionRepository;
    const isHost = true;

    setUpAll(() {
      registerFallbackValue(match);
      registerFallbackValue(matchState);
    });

    setUp(() {
      connectionRepository = _MockConnectionRepository();
      matchSolver = _MockMatchSolver();
      audioController = _MockAudioController();
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

    const hostCards = [
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
    ];

    const guestCards = [
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
    ];

    const baseState = MatchLoadedState(
      playerScoreCard: ScoreCard(id: 'scoreCardId'),
      match: Match(
        id: 'matchId',
        hostDeck: Deck(
          id: 'hostDeck',
          userId: 'hostUserId',
          cards: hostCards,
        ),
        guestDeck: Deck(
          id: 'guestDeck',
          userId: 'guestUserId',
          cards: guestCards,
        ),
      ),
      matchState: MatchState(
        id: 'matchStateId',
        matchId: 'matchId',
        hostPlayedCards: [],
        guestPlayedCards: [],
      ),
      rounds: [],
      turnAnimationsFinished: true,
      isFightScene: false,
      showCardLanding: false,
      turnTimeRemaining: 10,
    );

    test('can be instantiated', () {
      expect(
        GameBloc(
          gameResource: _MockGameResource(),
          matchMakerRepository: _MockMatchMakerRepository(),
          audioController: audioController,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          connectionRepository: _MockConnectionRepository(),
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
          audioController: audioController,
          user: user,
          isHost: false,
          connectionRepository: _MockConnectionRepository(),
        ).state,
        equals(MatchLoadingState()),
      );
    });

    blocTest<GameBloc, GameState>(
      'loads a match',
      build: () => GameBloc(
        gameResource: gameResource,
        matchMakerRepository: matchMakerRepository,
        audioController: audioController,
        matchSolver: matchSolver,
        user: user,
        isHost: isHost,
        connectionRepository: connectionRepository,
      ),
      act: (bloc) => bloc.add(MatchRequested(match.id)),
      expect: () => [
        MatchLoadingState(),
        MatchLoadedState(
          playerScoreCard: ScoreCard(id: 'scoreCardId'),
          match: match,
          matchState: matchState,
          rounds: const [],
          turnAnimationsFinished: true,
          turnTimeRemaining: 10,
          isFightScene: false,
          showCardLanding: false,
        ),
      ],
      verify: (_) {
        verify(() => gameResource.getMatch(match.id)).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'plays the startGame sfx when match is loaded',
      build: () => GameBloc(
        gameResource: gameResource,
        matchMakerRepository: matchMakerRepository,
        audioController: audioController,
        matchSolver: matchSolver,
        user: user,
        isHost: isHost,
        connectionRepository: connectionRepository,
      ),
      act: (bloc) => bloc.add(MatchRequested(match.id)),
      verify: (_) {
        verify(() => audioController.playSfx(Assets.sfx.startGame)).called(1);
      },
    );

    blocTest<GameBloc, GameState>(
      'fails when the match is not found',
      build: () => GameBloc(
        gameResource: gameResource,
        matchMakerRepository: matchMakerRepository,
        audioController: audioController,
        matchSolver: matchSolver,
        user: user,
        isHost: isHost,
        connectionRepository: connectionRepository,
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
        audioController: audioController,
        matchSolver: matchSolver,
        user: user,
        isHost: isHost,
        connectionRepository: connectionRepository,
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
          () => matchSolver.isPlayerAllowedToPlay(
            any(),
            isHost: any(named: 'isHost'),
          ),
        ).thenReturn(true);
        final bloc = GameBloc(
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          audioController: audioController,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          connectionRepository: connectionRepository,
        )..add(MatchRequested(baseState.match.id));

        await Future.microtask(() {});

        matchStateController.add(
          MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.matchId,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            guestPlayedCards: const ['card6'],
          ),
        );

        await Future<void>.delayed(Duration(milliseconds: 20));

        final state = bloc.state;
        expect(state, isA<MatchLoadedState>());

        final matchLoadedState = state as MatchLoadedState;
        expect(
          matchLoadedState.rounds,
          equals(
            [
              MatchRound(
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
          audioController: audioController,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          isHost: true,
          connectionRepository: connectionRepository,
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
          audioController: audioController,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          connectionRepository: connectionRepository,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              baseState.matchState,
              isHost: true,
            ),
          ).thenReturn(true);
        },
        seed: () => baseState,
        act: (bloc) => bloc.isPlayerAllowedToPlay,
        verify: (_) {
          verify(
            () => matchSolver.isPlayerAllowedToPlay(
              baseState.matchState,
              isHost: true,
            ),
          ).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'canPlayerPlay calls match solver correctly',
        build: () => GameBloc(
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          audioController: audioController,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
          connectionRepository: connectionRepository,
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

      group('GameResult', () {
        blocTest<GameBloc, GameState>(
          'gameResult returns win if host won, and the player is the host',
          build: () => GameBloc(
            connectionRepository: connectionRepository,
            audioController: audioController,
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
              result: MatchResult.host,
            ),
          ),
          verify: (bloc) {
            expect(
              bloc.gameResult(),
              equals(GameResult.win),
            );
          },
        );

        blocTest<GameBloc, GameState>(
          'gameResult returns win if guest won, and the player is the guest',
          build: () => GameBloc(
            connectionRepository: connectionRepository,
            gameResource: gameResource,
            audioController: audioController,
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
              result: MatchResult.guest,
            ),
          ),
          verify: (bloc) {
            expect(
              bloc.gameResult(),
              equals(GameResult.win),
            );
          },
        );

        blocTest<GameBloc, GameState>(
          'gameResult returns lose if host lost, and the player is the host',
          build: () => GameBloc(
            connectionRepository: connectionRepository,
            audioController: audioController,
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
              result: MatchResult.guest,
            ),
          ),
          verify: (bloc) {
            expect(
              bloc.gameResult(),
              equals(GameResult.lose),
            );
          },
        );

        blocTest<GameBloc, GameState>(
          'gameResult returns lose if guest lost, and the player is the guest',
          build: () => GameBloc(
            connectionRepository: connectionRepository,
            gameResource: gameResource,
            audioController: audioController,
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
              result: MatchResult.host,
            ),
          ),
          verify: (bloc) {
            expect(
              bloc.gameResult(),
              equals(GameResult.lose),
            );
          },
        );
      });

      blocTest<GameBloc, GameState>(
        'Play gameLost sound when host lost and player is the host',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
          ).thenReturn(true);
        },
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.id,
            guestPlayedCards: baseState.matchState.guestPlayedCards,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            result: MatchResult.guest,
          ),
        ),
        act: (bloc) {
          bloc.add(
            MatchStateUpdated(
              MatchState(
                id: baseState.matchState.id,
                matchId: baseState.matchState.matchId,
                guestPlayedCards: baseState.matchState.guestPlayedCards,
                hostPlayedCards: baseState.matchState.hostPlayedCards,
                result: MatchResult.guest,
              ),
            ),
          );
        },
        verify: (_) {
          verify(() => audioController.playSfx(Assets.sfx.lostMatch)).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'Play gameLost sound when guest lost and player is the guest',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: false,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
          ).thenReturn(true);
        },
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.id,
            guestPlayedCards: baseState.matchState.guestPlayedCards,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            result: MatchResult.guest,
          ),
        ),
        act: (bloc) {
          bloc.add(
            MatchStateUpdated(
              MatchState(
                id: baseState.matchState.id,
                matchId: baseState.matchState.matchId,
                guestPlayedCards: baseState.matchState.guestPlayedCards,
                hostPlayedCards: baseState.matchState.hostPlayedCards,
                result: MatchResult.host,
              ),
            ),
          );
        },
        verify: (_) {
          verify(() => audioController.playSfx(Assets.sfx.lostMatch)).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'Play gameWin sound when host won and player is the host',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
          ).thenReturn(true);
        },
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.id,
            guestPlayedCards: baseState.matchState.guestPlayedCards,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            result: MatchResult.guest,
          ),
        ),
        act: (bloc) {
          bloc.add(
            MatchStateUpdated(
              MatchState(
                id: baseState.matchState.id,
                matchId: baseState.matchState.matchId,
                guestPlayedCards: baseState.matchState.guestPlayedCards,
                hostPlayedCards: baseState.matchState.hostPlayedCards,
                result: MatchResult.host,
              ),
            ),
          );
        },
        verify: (_) {
          verify(() => audioController.playSfx(Assets.sfx.winMatch)).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'Play gameWin sound when guest won and player is the guest',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: false,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
          ).thenReturn(true);
        },
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.id,
            guestPlayedCards: baseState.matchState.guestPlayedCards,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            result: MatchResult.guest,
          ),
        ),
        act: (bloc) {
          bloc.add(
            MatchStateUpdated(
              MatchState(
                id: baseState.matchState.id,
                matchId: baseState.matchState.matchId,
                guestPlayedCards: baseState.matchState.guestPlayedCards,
                hostPlayedCards: baseState.matchState.hostPlayedCards,
                result: MatchResult.guest,
              ),
            ),
          );
        },
        verify: (_) {
          verify(() => audioController.playSfx(Assets.sfx.winMatch)).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'Play draw sound when match ends in a draw',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: false,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
          ).thenReturn(true);
        },
        seed: () => baseState.copyWith(
          matchState: MatchState(
            id: baseState.matchState.id,
            matchId: baseState.matchState.id,
            guestPlayedCards: baseState.matchState.guestPlayedCards,
            hostPlayedCards: baseState.matchState.hostPlayedCards,
            result: MatchResult.guest,
          ),
        ),
        act: (bloc) {
          bloc.add(
            MatchStateUpdated(
              MatchState(
                id: baseState.matchState.id,
                matchId: baseState.matchState.matchId,
                guestPlayedCards: baseState.matchState.guestPlayedCards,
                hostPlayedCards: baseState.matchState.hostPlayedCards,
                result: MatchResult.draw,
              ),
            ),
          );
        },
        verify: (_) {
          verify(() => audioController.playSfx(Assets.sfx.drawMatch)).called(1);
        },
      );

      group('isWinningCard', () {
        blocTest<GameBloc, GameState>(
          'returns correctly when host is card is from player',
          build: () => GameBloc(
            gameResource: gameResource,
            matchMakerRepository: matchMakerRepository,
            matchSolver: matchSolver,
            audioController: audioController,
            user: user,
            isHost: true,
            connectionRepository: connectionRepository,
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
            ),
            rounds: [
              MatchRound(
                playerCardId: 'card1',
                opponentCardId: 'card6',
                showCardsOverlay: true,
              ),
            ],
          ),
          verify: (bloc) {
            expect(
              bloc.isWinningCard(
                baseState.match.hostDeck.cards
                    .firstWhere((card) => card.id == 'card1'),
                isPlayer: true,
              ),
              equals(CardOverlayType.win),
            );
          },
        );
        blocTest<GameBloc, GameState>(
          'returns correctly when is host and card is from opponent',
          build: () => GameBloc(
            gameResource: gameResource,
            audioController: audioController,
            matchMakerRepository: matchMakerRepository,
            matchSolver: matchSolver,
            user: user,
            isHost: true,
            connectionRepository: connectionRepository,
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
            ),
            rounds: [
              MatchRound(
                playerCardId: 'card1',
                opponentCardId: 'card6',
                showCardsOverlay: true,
              ),
            ],
          ),
          verify: (bloc) {
            expect(
              bloc.isWinningCard(
                baseState.match.guestDeck.cards
                    .firstWhere((card) => card.id == 'card6'),
                isPlayer: false,
              ),
              equals(CardOverlayType.lose),
            );
          },
        );

        blocTest<GameBloc, GameState>(
          'returns correctly when is guest and card is from player',
          build: () => GameBloc(
            connectionRepository: connectionRepository,
            audioController: audioController,
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
            ),
            rounds: [
              MatchRound(
                playerCardId: 'card6',
                opponentCardId: 'card1',
                showCardsOverlay: true,
              ),
            ],
          ),
          verify: (bloc) {
            expect(
              bloc.isWinningCard(
                baseState.match.guestDeck.cards
                    .firstWhere((card) => card.id == 'card6'),
                isPlayer: true,
              ),
              equals(CardOverlayType.win),
            );
          },
        );

        blocTest<GameBloc, GameState>(
          'returns correctly when is guest and card is from opponent',
          build: () => GameBloc(
            connectionRepository: connectionRepository,
            gameResource: gameResource,
            matchMakerRepository: matchMakerRepository,
            audioController: audioController,
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
            ),
            rounds: [
              MatchRound(
                playerCardId: 'card6',
                opponentCardId: 'card1',
                showCardsOverlay: true,
              ),
            ],
          ),
          verify: (bloc) {
            expect(
              bloc.isWinningCard(
                baseState.match.hostDeck.cards
                    .firstWhere((card) => card.id == 'card1'),
                isPlayer: false,
              ),
              equals(CardOverlayType.lose),
            );
          },
        );
      });

      blocTest<GameBloc, GameState>(
        'plays a player card',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          audioController: audioController,
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
            ),
            rounds: const [],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays a player card when being the guest',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          audioController: audioController,
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
            ),
            rounds: const [],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'Last card is played with no result then calls calculateResult',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          audioController: audioController,
          matchSolver: matchSolver,
          user: user,
          isHost: false,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
          ).thenReturn(true);
          when(
            () => gameResource.calculateResult(
              match: any(named: 'match'),
              matchState: any(named: 'matchState'),
            ),
          ).thenAnswer((invocation) async {});
        },
        seed: () => baseState,
        act: (bloc) => bloc.add(
          MatchStateUpdated(
            MatchState(
              id: baseState.matchState.id,
              matchId: baseState.matchState.matchId,
              hostPlayedCards: const ['new_card_1', 'new_card_2', 'new_card_3'],
              guestPlayedCards: const [
                'new_card_4',
                'new_card_5',
                'new_card_6',
              ],
            ),
          ),
        ),
        verify: (_) {
          verify(
            () => gameResource.calculateResult(
              match: baseState.match,
              matchState: baseState.matchState,
            ),
          ).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'Plays playCard sound when card is played by both players',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          audioController: audioController,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
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
                ),
              ),
            );
        },
        verify: (_) {
          verify(() => audioController.playSfx(Assets.sfx.playCard)).called(2);
        },
      );

      blocTest<GameBloc, GameState>(
        'plays a player card, receives confirmation and then receives an '
        'opponent card',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          audioController: audioController,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
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
            ),
            rounds: const [],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const ['new_card_1'],
            ),
            rounds: const [
              MatchRound(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const ['new_card_2'],
              hostPlayedCards: const ['new_card_1'],
            ),
            rounds: const [
              MatchRound(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
            ],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays a player card and opponent card and another opponent one',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          matchSolver: matchSolver,
          user: user,
          isHost: true,
        ),
        setUp: () {
          when(
            () => matchSolver.isPlayerAllowedToPlay(
              any(),
              isHost: any(named: 'isHost'),
            ),
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
            ),
            rounds: const [],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const ['new_card_1'],
            ),
            rounds: const [
              MatchRound(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const ['new_card_2'],
              hostPlayedCards: const ['new_card_1'],
            ),
            rounds: const [
              MatchRound(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
            ],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
          MatchLoadedState(
            playerScoreCard: ScoreCard(id: 'scoreCardId'),
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const ['new_card_2', 'new_card_3'],
              hostPlayedCards: const ['new_card_1'],
            ),
            rounds: const [
              MatchRound(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
              MatchRound(
                opponentCardId: 'new_card_3',
                playerCardId: null,
              ),
            ],
            turnAnimationsFinished: false,
            turnTimeRemaining: 10,
            isFightScene: false,
            showCardLanding: false,
          ),
        ],
      );

      group('- turn countdown', () {
        test('starts correctly', () {
          fakeAsync((async) {
            when(
              () => matchSolver.isPlayerAllowedToPlay(
                any(),
                isHost: any(named: 'isHost'),
              ),
            ).thenReturn(true);
            final stream =
                StreamController<DraftMatch>(onCancel: () async {}).stream;
            when(() => matchMakerRepository.watchMatch(any())).thenAnswer(
              (_) => stream,
            );

            final bloc = GameBloc(
              connectionRepository: connectionRepository,
              gameResource: gameResource,
              matchMakerRepository: matchMakerRepository,
              audioController: audioController,
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
                  rounds: const [],
                  turnAnimationsFinished: true,
                  turnTimeRemaining: 8,
                  isFightScene: false,
                  showCardLanding: false,
                ),
              ),
            );
            bloc.close();
          });
        });

        test('ends and plays card automatically for host', () {
          fakeAsync((async) {
            when(
              () => matchSolver.isPlayerAllowedToPlay(
                any(),
                isHost: any(named: 'isHost'),
              ),
            ).thenReturn(true);
            when(() => gameResource.getMatch(any())).thenAnswer((_) async {
              return baseState.match;
            });

            final bloc = GameBloc(
              connectionRepository: connectionRepository,
              audioController: audioController,
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
            bloc.close();
          });
        });

        test('ends and plays card automatically for guest', () {
          fakeAsync((async) {
            when(
              () => matchSolver.isPlayerAllowedToPlay(
                any(),
                isHost: any(named: 'isHost'),
              ),
            ).thenReturn(true);
            when(() => gameResource.getMatch(any())).thenAnswer((_) async {
              return baseState.match;
            });

            final bloc = GameBloc(
              connectionRepository: connectionRepository,
              gameResource: gameResource,
              audioController: audioController,
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
            bloc.close();
          });
        });

        test("ends and doesn't play card automatically if already played", () {
          fakeAsync((async) {
            when(
              () => matchSolver.isPlayerAllowedToPlay(
                any(),
                isHost: any(named: 'isHost'),
              ),
            ).thenReturn(false);
            when(() => gameResource.getMatch(any())).thenAnswer((_) async {
              return baseState.match;
            });

            final bloc = GameBloc(
              connectionRepository: connectionRepository,
              gameResource: gameResource,
              audioController: audioController,
              matchMakerRepository: matchMakerRepository,
              matchSolver: matchSolver,
              user: user,
              isHost: false,
            )
              ..add(MatchRequested(baseState.match.id))
              ..add(MatchStateUpdated(baseState.matchState));

            async.elapse(Duration(milliseconds: 10500));

            verifyNever(
              () => gameResource.playCard(
                matchId: any(named: 'matchId'),
                cardId: any(named: 'cardId'),
                deckId: any(named: 'deckId'),
              ),
            );
            bloc.close();
          });
        });
      });
    });

    blocTest<GameBloc, GameState>(
      'playerCards returns host cards if is host',
      build: () => GameBloc(
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        audioController: audioController,
        matchMakerRepository: matchMakerRepository,
        matchSolver: matchSolver,
        isHost: true,
        user: user,
      ),
      seed: () => baseState,
      verify: (bloc) {
        expect(bloc.playerCards, equals(hostCards));
      },
    );

    blocTest<GameBloc, GameState>(
      'playerCards returns guest cards if is guest',
      build: () => GameBloc(
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        audioController: audioController,
        matchMakerRepository: matchMakerRepository,
        matchSolver: matchSolver,
        isHost: false,
        user: user,
      ),
      seed: () => baseState,
      verify: (bloc) {
        expect(bloc.playerCards, equals(guestCards));
      },
    );

    blocTest<GameBloc, GameState>(
      'opponentCards returns host cards if player is not host',
      build: () => GameBloc(
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        matchMakerRepository: matchMakerRepository,
        audioController: audioController,
        matchSolver: matchSolver,
        isHost: false,
        user: user,
      ),
      seed: () => baseState,
      verify: (bloc) {
        expect(bloc.opponentCards, equals(hostCards));
      },
    );

    blocTest<GameBloc, GameState>(
      'opponentCards returns guest cards if player is host',
      build: () => GameBloc(
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        audioController: audioController,
        matchMakerRepository: matchMakerRepository,
        matchSolver: matchSolver,
        isHost: true,
        user: user,
      ),
      seed: () => baseState,
      verify: (bloc) {
        expect(bloc.opponentCards, equals(guestCards));
      },
    );

    blocTest<GameBloc, GameState>(
      'playerCards and opponentCards returns empty if state is not '
      'MatchLoadedState',
      build: () => GameBloc(
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        audioController: audioController,
        matchMakerRepository: matchMakerRepository,
        matchSolver: matchSolver,
        isHost: true,
        user: user,
      ),
      seed: MatchLoadingState.new,
      verify: (bloc) {
        expect(bloc.playerCards, isEmpty);
        expect(bloc.opponentCards, isEmpty);
      },
    );

    blocTest<GameBloc, GameState>(
      'last played cards for player and opponent return correctly',
      build: () => GameBloc(
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        audioController: audioController,
        matchMakerRepository: matchMakerRepository,
        matchSolver: matchSolver,
        isHost: true,
        user: user,
      ),
      seed: () => baseState.copyWith(
        rounds: [
          MatchRound(
            playerCardId: hostCards.first.id,
            opponentCardId: guestCards.first.id,
          )
        ],
      ),
      verify: (bloc) {
        expect(bloc.lastPlayedPlayerCard, equals(hostCards.first));
        expect(bloc.lastPlayedOpponentCard, equals(guestCards.first));
      },
    );

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
          rounds: const [],
          turnAnimationsFinished: false,
          turnTimeRemaining: 10,
          isFightScene: false,
          showCardLanding: false,
        );

        test('returns true if the card is the winning one', () {
          final state = baseState.copyWith(
            rounds: [
              MatchRound(
                opponentCardId: card.id,
                playerCardId: 'a',
              ),
            ],
          );

          expect(state.isCardTurnComplete(card), isTrue);
        });

        test('returns false if the turn is not complete', () {
          final state = baseState.copyWith(
            rounds: [
              MatchRound(
                opponentCardId: card.id,
                playerCardId: null,
              ),
            ],
          );

          expect(state.isCardTurnComplete(card), isFalse);
        });

        test('can detect the card turn no matter the order', () {
          final state = baseState.copyWith(
            rounds: [
              MatchRound(
                opponentCardId: 'a',
                playerCardId: card.id,
              ),
              MatchRound(
                opponentCardId: 'b',
                playerCardId: null,
              ),
            ],
          );

          expect(state.isCardTurnComplete(card), isTrue);
        });
      });
    });

    group('MatchRound', () {
      test('isComplete', () {
        expect(
          MatchRound(playerCardId: null, opponentCardId: null).isComplete(),
          isFalse,
        );

        expect(
          MatchRound(playerCardId: 'a', opponentCardId: null).isComplete(),
          isFalse,
        );

        expect(
          MatchRound(playerCardId: null, opponentCardId: 'a').isComplete(),
          isFalse,
        );

        expect(
          MatchRound(playerCardId: 'b', opponentCardId: 'a').isComplete(),
          isTrue,
        );
      });
    });

    group('manage player presence', () {
      blocTest<GameBloc, GameState>(
        'notifies when opponent(guest) is absent',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        act: (bloc) {
          bloc.add(ManagePlayerPresence(match.id));
          matchController.add(
            DraftMatch(
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
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          audioController: audioController,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: false,
          matchSolver: matchSolver,
        ),
        act: (bloc) {
          bloc.add(ManagePlayerPresence(match.id));
          matchController.add(
            DraftMatch(
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
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          audioController: audioController,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        act: (bloc) {
          bloc.add(ManagePlayerPresence(match.id));
          matchController.add(
            DraftMatch(
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
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          audioController: audioController,
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
            DraftMatch(
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

      blocTest<GameBloc, GameState>(
        'does not return a state if game is over and opponent leaves match',
        setUp: () {
          when(() => gameResource.getMatchState(any())).thenAnswer(
            (_) async => MatchState(
              id: 'id',
              matchId: 'matchId',
              hostPlayedCards: const ['card1', 'card2', 'card3'],
              guestPlayedCards: const ['card4', 'card5', 'card6'],
            ),
          );
        },
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          audioController: audioController,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        act: (bloc) {
          bloc.add(ManagePlayerPresence(match.id));
          matchController.add(
            DraftMatch(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
              hostConnected: true,
            ),
          );
        },
        expect: () => <GameState>[],
        verify: (_) {
          verify(() => matchMakerRepository.watchMatch(match.id)).called(1);
          verify(() => gameResource.getMatchState(match.id)).called(1);
        },
      );
    });

    group('LeaderboardEntryRequested', () {
      blocTest<GameBloc, GameState>(
        'emits LeaderboardEntryState when leaderboard entry is requested',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          audioController: audioController,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        act: (bloc) => bloc.add(LeaderboardEntryRequested()),
        seed: () => baseState,
        expect: () => <GameState>[
          LeaderboardEntryState(baseState.playerScoreCard.id),
        ],
      );
    });

    group('turnAnimationsFinished', () {
      blocTest<GameBloc, GameState>(
        'emits state updating turnAnimationsFinished field and '
        'adds TurnTimerStarted event',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          audioController: audioController,
          isHost: true,
          matchSolver: matchSolver,
        ),
        seed: () => baseState.copyWith(turnAnimationsFinished: false),
        act: (bloc) => bloc.add(TurnAnimationsFinished()),
        expect: () => <GameState>[
          baseState.copyWith(turnAnimationsFinished: true, isFightScene: false),
        ],
      );
    });

    group('turnAnimationsFinished', () {
      blocTest<GameBloc, GameState>(
        'plays clock running when timer reaches 3 seconds',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          audioController: audioController,
          isHost: true,
          matchSolver: matchSolver,
        ),
        seed: () => baseState.copyWith(turnTimeRemaining: 4),
        act: (bloc) => bloc.add(TurnTimerTicked(_MockTimer())),
        verify: (_) {
          verify(() => audioController.playSfx(Assets.sfx.clockRunning))
              .called(1);
        },
      );
    });

    group('ClashSceneStarted', () {
      blocTest<GameBloc, GameState>(
        'emits state updating showCardsOverlay field and isFightScene',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        seed: () => baseState.copyWith(
          rounds: [
            MatchRound(
              playerCardId: hostCards.first.id,
              opponentCardId: guestCards.first.id,
            )
          ],
        ),
        act: (bloc) => bloc.add(ClashSceneStarted()),
        expect: () => <GameState>[
          baseState.copyWith(
            rounds: [
              MatchRound(
                playerCardId: hostCards.first.id,
                opponentCardId: guestCards.first.id,
                showCardsOverlay: true,
              )
            ],
            isFightScene: true,
          ),
        ],
      );
    });

    group('FightSceneCompleted', () {
      blocTest<GameBloc, GameState>(
        'emits state updating isFightScene field',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        seed: () => baseState.copyWith(isFightScene: true),
        act: (bloc) => bloc.add(FightSceneCompleted()),
        expect: () => <GameState>[
          baseState.copyWith(isFightScene: false),
        ],
      );
    });

    group('CardLandingStarted', () {
      blocTest<GameBloc, GameState>(
        'emits state updating showCardLanding field',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        seed: () => baseState,
        act: (bloc) => bloc.add(CardLandingStarted()),
        expect: () => <GameState>[
          baseState.copyWith(showCardLanding: true),
        ],
      );
    });

    group('CardLandingCompleted', () {
      blocTest<GameBloc, GameState>(
        'emits state updating showCardLanding field',
        build: () => GameBloc(
          connectionRepository: connectionRepository,
          audioController: audioController,
          gameResource: gameResource,
          matchMakerRepository: matchMakerRepository,
          user: user,
          isHost: true,
          matchSolver: matchSolver,
        ),
        seed: () => baseState.copyWith(showCardLanding: true),
        act: (bloc) => bloc.add(CardLandingCompleted()),
        expect: () => <GameState>[
          baseState.copyWith(showCardLanding: false),
        ],
      );
    });
  });
}
