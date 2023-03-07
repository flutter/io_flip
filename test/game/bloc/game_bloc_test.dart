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

    group('register player and opponent moves', () {
      const baseState = MatchLoadedState(
        match: Match(
          id: 'matchId',
          hostDeck: Deck(
            id: 'hostDeck',
            cards: [
              Card(
                id: 'card1',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
              ),
              Card(
                id: 'card2',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
              ),
              Card(
                id: 'card3',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
              ),
            ],
          ),
          guestDeck: Deck(
            id: 'guestDeck',
            cards: [
              Card(
                id: 'card4',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
              ),
              Card(
                id: 'card5',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
              ),
              Card(
                id: 'card6',
                name: '',
                description: '',
                image: '',
                power: 10,
                rarity: false,
              ),
            ],
          ),
        ),
        matchState: MatchState(
          id: 'matchStateId',
          matchId: 'matchId',
          hostPlayedCards: [],
          guestPlayedCards: [],
        ),
        turns: [],
      );

      setUp(() {
        when(
          () => gameClient.playCard(
            matchId: 'matchId',
            cardId: any(named: 'cardId'),
            isHost: any(named: 'isHost'),
          ),
        ).thenAnswer((_) async {});
      });

      blocTest<GameBloc, GameState>(
        'plays a player card',
        build: () => GameBloc(
          gameClient: gameClient,
          matchMakerRepository: matchMakerRepository,
          isHost: true,
        ),
        seed: () => baseState,
        act: (bloc) => bloc.add(PlayerPlayed('new_card_1')),
        expect: () => [
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays an opponent card',
        build: () => GameBloc(
          gameClient: gameClient,
          matchMakerRepository: matchMakerRepository,
          isHost: true,
        ),
        seed: () => baseState,
        act: (bloc) => bloc.add(OpponentPlayed('new_card_1')),
        expect: () => [
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_1',
                playerCardId: null,
              ),
            ],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays a player card and opponent card',
        build: () => GameBloc(
          gameClient: gameClient,
          matchMakerRepository: matchMakerRepository,
          isHost: true,
        ),
        seed: () => baseState,
        act: (bloc) {
          bloc
            ..add(PlayerPlayed('new_card_1'))
            ..add(OpponentPlayed('new_card_2'));
        },
        expect: () => [
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
            ],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays a player card and opponent card and another opponent one',
        build: () => GameBloc(
          gameClient: gameClient,
          matchMakerRepository: matchMakerRepository,
          isHost: true,
        ),
        seed: () => baseState,
        act: (bloc) {
          bloc
            ..add(PlayerPlayed('new_card_1'))
            ..add(OpponentPlayed('new_card_2'))
            ..add(OpponentPlayed('new_card_3'));
        },
        expect: () => [
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
            ],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
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
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays an opponent card and player card and another player one',
        build: () => GameBloc(
          gameClient: gameClient,
          matchMakerRepository: matchMakerRepository,
          isHost: true,
        ),
        seed: () => baseState,
        act: (bloc) {
          bloc
            ..add(OpponentPlayed('new_card_1'))
            ..add(PlayerPlayed('new_card_2'))
            ..add(PlayerPlayed('new_card_3'));
        },
        expect: () => [
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_1',
                playerCardId: null,
              ),
            ],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_1',
                playerCardId: 'new_card_2',
              ),
            ],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_1',
                playerCardId: 'new_card_2',
              ),
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_3',
              ),
            ],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'plays a player card and opponent card and another player one',
        build: () => GameBloc(
          gameClient: gameClient,
          matchMakerRepository: matchMakerRepository,
          isHost: true,
        ),
        seed: () => baseState,
        act: (bloc) {
          bloc
            ..add(PlayerPlayed('new_card_1'))
            ..add(OpponentPlayed('new_card_2'))
            ..add(PlayerPlayed('new_card_3'));
        },
        expect: () => [
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_1',
              ),
            ],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
            ],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_2',
                playerCardId: 'new_card_1',
              ),
              MatchTurn(
                opponentCardId: null,
                playerCardId: 'new_card_3',
              ),
            ],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'adds an opponent move when the entity is updated',
        build: () => GameBloc(
          gameClient: gameClient,
          matchMakerRepository: matchMakerRepository,
          isHost: true,
        ),
        setUp: () {
          when(() => gameClient.getMatch(baseState.match.id)).thenAnswer(
            (_) async => baseState.match,
          );
          when(() => gameClient.getMatchState(baseState.match.id))
              .thenAnswer((_) async => baseState.matchState);
        },
        act: (bloc) {
          bloc.add(MatchRequested(baseState.match.id));
          guestController.add('new_card_1');
        },
        expect: () => [
          MatchLoadingState(),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_1',
                playerCardId: null,
              ),
            ],
          ),
        ],
      );

      blocTest<GameBloc, GameState>(
        'adds an opponent move when the entity is updated when player is '
        'not the host',
        build: () => GameBloc(
          gameClient: gameClient,
          matchMakerRepository: matchMakerRepository,
          isHost: false,
        ),
        setUp: () {
          when(() => gameClient.getMatch(baseState.match.id)).thenAnswer(
            (_) async => baseState.match,
          );
          when(() => gameClient.getMatchState(baseState.match.id))
              .thenAnswer((_) async => baseState.matchState);
        },
        act: (bloc) {
          bloc.add(MatchRequested(baseState.match.id));
          hostController.add('new_card_1');
        },
        expect: () => [
          MatchLoadingState(),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [],
          ),
          MatchLoadedState(
            match: baseState.match,
            matchState: MatchState(
              id: 'matchStateId',
              matchId: baseState.match.id,
              guestPlayedCards: const [],
              hostPlayedCards: const [],
            ),
            turns: const [
              MatchTurn(
                opponentCardId: 'new_card_1',
                playerCardId: null,
              ),
            ],
          ),
        ],
      );
    });

    group('MatchLoadedState', () {
      group('isCardTurnComplete', () {
        final cards = List.generate(
          6,
          (i) => Card(
            id: i.toString(),
            name: '',
            description: '',
            image: '',
            power: 1 + i,
            rarity: false,
          ),
        );

        final baseState = MatchLoadedState(
          match: Match(
            id: '',
            hostDeck: Deck(
              id: '',
              cards: [cards[0], cards[2], cards[4]],
            ),
            guestDeck: Deck(
              id: '',
              cards: [cards[1], cards[3], cards[5]],
            ),
          ),
          matchState: MatchState(
            id: '',
            matchId: '',
            hostPlayedCards: const [],
            guestPlayedCards: const [],
          ),
          turns: const [],
        );

        test('returns true if the turn is complete and the card won', () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(playerCardId: cards[4].id, opponentCardId: cards[1].id),
            ],
          );
          expect(state.isWiningCard(cards[4]), isTrue);
        });

        test("returns false if the turn is complete but the card didn't win",
            () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(playerCardId: cards[2].id, opponentCardId: cards[5].id),
            ],
          );
          expect(state.isWiningCard(cards[2]), isFalse);
        });

        test("returns false if the turn isn't complete", () {
          final state = baseState.copyWith(
            turns: [
              MatchTurn(playerCardId: cards[4].id, opponentCardId: null),
            ],
          );
          expect(state.isWiningCard(cards[4]), isFalse);
        });

        group('when the card is the opponent', () {
          test('returns true if the turn is complete and the card won', () {
            final state = baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: cards[0].id,
                  opponentCardId: cards[1].id,
                ),
              ],
            );
            expect(state.isWiningCard(cards[1]), isTrue);
          });

          test("returns false if the turn is complete but the card didn't win",
              () {
            final state = baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: cards[2].id,
                  opponentCardId: cards[3].id,
                ),
              ],
            );
            expect(state.isWiningCard(cards[2]), isFalse);
          });

          test("returns false if the turn isn't complete", () {
            final state = baseState.copyWith(
              turns: [
                MatchTurn(playerCardId: null, opponentCardId: cards[1].id),
              ],
            );
            expect(state.isWiningCard(cards[1]), isFalse);
          });
        });
      });

      group('isWiningCard', () {
        final match1 = Match(
          id: 'match1',
          hostDeck: Deck(id: '', cards: const []),
          guestDeck: Deck(id: '', cards: const []),
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
        );

        final baseState = MatchLoadedState(
          match: match1,
          matchState: matchState1,
          turns: const [],
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
  });
}
