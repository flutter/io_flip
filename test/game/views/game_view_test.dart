// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  group('GameView', () {
    late GameBloc bloc;
    late LeaderboardResource leaderboardResource;

    const playerCards = [
      Card(
        id: 'player_card',
        name: 'host_card',
        description: '',
        image: '',
        rarity: true,
        power: 2,
        suit: Suit.air,
      ),
      Card(
        id: 'player_card_2',
        name: 'host_card_2',
        description: '',
        image: '',
        rarity: true,
        power: 2,
        suit: Suit.air,
      ),
    ];
    const opponentCards = [
      Card(
        id: 'opponent_card',
        name: 'guest_card',
        description: '',
        image: '',
        rarity: true,
        power: 1,
        suit: Suit.air,
      ),
    ];

    setUpAll(() {
      registerFallbackValue(
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          power: 0,
          rarity: false,
          suit: Suit.air,
        ),
      );
    });

    setUp(() {
      bloc = _MockGameBloc();
      when(() => bloc.isHost).thenReturn(true);
      when(() => bloc.isWinningCard(any(), isPlayer: any(named: 'isPlayer')))
          .thenReturn(null);
      when(() => bloc.canPlayerPlay(any())).thenReturn(true);
      when(() => bloc.isPlayerTurn).thenReturn(true);
      when(bloc.hasPlayerWon).thenReturn(false);

      leaderboardResource = _MockLeaderboardResource();
      when(() => leaderboardResource.getInitialsBlacklist())
          .thenAnswer((_) async => ['WTF']);
    });

    void mockState(GameState state) {
      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );
    }

    testWidgets('renders a loading when on initial state', (tester) async {
      mockState(MatchLoadingState());
      await tester.pumpSubject(bloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders an error message when failed', (tester) async {
      mockState(MatchLoadFailedState());
      await tester.pumpSubject(bloc);
      expect(find.text('Unable to join game!'), findsOneWidget);
    });

    group('Gameplay', () {
      final baseState = MatchLoadedState(
        playerScoreCard: ScoreCard(id: 'scoreCardId'),
        match: Match(
          id: '',
          hostDeck: Deck(id: '', userId: '', cards: playerCards),
          guestDeck: Deck(id: '', userId: '', cards: opponentCards),
        ),
        matchState: MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
          hostStartsMatch: true,
        ),
        turns: const [],
        turnTimeRemaining: 10,
        turnAnimationsFinished: true,
      );

      setUp(() {
        when(() => bloc.playerCards).thenReturn(playerCards);
        when(() => bloc.opponentCards).thenReturn(opponentCards);
      });

      testWidgets('renders the game in its initial state', (tester) async {
        mockState(baseState);
        await tester.pumpSubject(bloc);

        expect(
          find.byKey(const Key('opponent_hidden_card_opponent_card')),
          findsOneWidget,
        );

        expect(
          find.byKey(const Key('player_card_player_card')),
          findsOneWidget,
        );
      });

      testWidgets(
        'renders leaderboard entry view when state is LeaderboardEntryState',
        (tester) async {
          mockState(LeaderboardEntryState('scoreCardId'));
          await tester.pumpSubject(
            bloc,
            leaderboardResource: leaderboardResource,
          );

          expect(find.byType(LeaderboardEntryView), findsOneWidget);
        },
      );

      testWidgets(
        'renders the opponent absent message when the opponent leaves',
        (tester) async {
          mockState(OpponentAbsentState());
          await tester.pumpSubject(bloc);

          expect(
            find.text('Opponent left the game!'),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(ElevatedButton, 'Replay'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'pops navigation when the replay button is tapped on opponent absent',
        (tester) async {
          final goRouter = MockGoRouter();

          mockState(OpponentAbsentState());

          await tester.pumpSubject(
            bloc,
            goRouter: goRouter,
          );

          await tester.tap(find.text('Replay'));
          await tester.pumpAndSettle();

          verify(goRouter.pop).called(1);
        },
      );

      testWidgets(
        'plays a player card on tap',
        (tester) async {
          mockState(baseState);
          await tester.pumpSubject(bloc);

          await tester.tap(find.byKey(const Key('player_card_player_card')));

          verify(() => bloc.add(PlayerPlayed('player_card'))).called(1);
        },
      );

      testWidgets(
        "can't play a card that was already played",
        (tester) async {
          mockState(
            baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: 'player_card',
                  opponentCardId: 'opponent_card',
                )
              ],
            ),
          );
          await tester.pumpSubject(bloc);

          await tester.tap(find.byKey(const Key('player_card_player_card')));

          verifyNever(() => bloc.add(PlayerPlayed('player_card')));
        },
      );

      testWidgets(
        "can't play when it is not the player turn",
        (tester) async {
          when(() => bloc.canPlayerPlay(any())).thenReturn(false);
          mockState(
            baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: 'player_card',
                  opponentCardId: null,
                )
              ],
            ),
          );
          await tester.pumpSubject(bloc);

          await tester.tap(find.byKey(const Key('player_card_player_card_2')));

          verifyNever(() => bloc.add(PlayerPlayed('player_card_2')));
        },
      );

      testWidgets(
        'render the opponent card instantly when played',
        (tester) async {
          mockState(
            baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: null,
                  opponentCardId: 'opponent_card',
                )
              ],
            ),
          );
          await tester.pumpSubject(bloc);

          expect(
            find.byKey(const Key('opponent_revealed_card_opponent_card')),
            findsOneWidget,
          );

          expect(
            find.byKey(const Key('player_card_player_card')),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'render the win overlay on the player winning card',
        (tester) async {
          when(
            () => bloc.isWinningCard(
              Card(
                id: 'player_card',
                name: 'host_card',
                description: '',
                image: '',
                rarity: true,
                power: 2,
                suit: Suit.air,
              ),
              isPlayer: true,
            ),
          ).thenReturn(CardOverlayType.win);

          mockState(
            baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: 'player_card',
                  opponentCardId: 'opponent_card',
                  showCardsOverlay: true,
                )
              ],
            ),
          );
          await tester.pumpSubject(bloc);

          expect(
            find.byKey(const Key('win_card_overlay')),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'render the win overlay on the opponent winning card',
        (tester) async {
          when(
            () => bloc.isWinningCard(
              any(),
              isPlayer: false,
            ),
          ).thenReturn(CardOverlayType.win);

          mockState(
            baseState.copyWith(
              match: Match(
                id: '',
                hostDeck: baseState.match.hostDeck,
                guestDeck: Deck(
                  id: '',
                  userId: '',
                  cards: const [
                    Card(
                      id: 'opponent_card',
                      name: 'guest_card',
                      description: '',
                      image: '',
                      rarity: true,
                      power: 10,
                      suit: Suit.air,
                    ),
                  ],
                ),
              ),
              turns: [
                MatchTurn(
                  playerCardId: 'player_card',
                  opponentCardId: 'opponent_card',
                  showCardsOverlay: true,
                )
              ],
            ),
          );
          await tester.pumpSubject(bloc);

          expect(
            find.byKey(const Key('win_card_overlay')),
            findsOneWidget,
          );
        },
      );
    });

    group('Card animation', () {
      final baseState = MatchLoadedState(
        playerScoreCard: ScoreCard(id: 'scoreCardId'),
        match: Match(
          id: '',
          hostDeck: Deck(id: '', userId: '', cards: playerCards),
          guestDeck: Deck(id: '', userId: '', cards: opponentCards),
        ),
        matchState: MatchState(
          id: '',
          matchId: '',
          guestPlayedCards: const [],
          hostPlayedCards: const [],
          hostStartsMatch: true,
        ),
        turns: const [],
        turnTimeRemaining: 10,
        turnAnimationsFinished: true,
      );

      setUp(() {
        when(() => bloc.playerCards).thenReturn(playerCards);
        when(() => bloc.opponentCards).thenReturn(opponentCards);
      });

      testWidgets('starts when player plays a card', (tester) async {
        when(() => bloc.lastPlayedCardId).thenReturn(playerCards.first.id);
        whenListen(
          bloc,
          Stream.fromIterable([
            baseState,
            baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: playerCards.first.id,
                  opponentCardId: null,
                )
              ],
            )
          ]),
          initialState: baseState,
        );

        await tester.pumpSubject(bloc);

        final cardFinder =
            find.byKey(Key('player_card_${playerCards.first.id}'));

        final initialOffset = tester.getCenter(cardFinder);
        await tester.pumpAndSettle();
        final finalOffset = tester.getCenter(cardFinder);

        expect(
          initialOffset,
          isNot(equals(finalOffset)),
        );
      });

      testWidgets('starts when opponent plays a card', (tester) async {
        when(() => bloc.lastPlayedCardId).thenReturn(opponentCards.first.id);
        whenListen(
          bloc,
          Stream.fromIterable([
            baseState,
            baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: null,
                  opponentCardId: opponentCards.first.id,
                )
              ],
            )
          ]),
          initialState: baseState,
        );

        await tester.pumpSubject(bloc);

        final cardFinder =
            find.byKey(Key('opponent_card_${opponentCards.first.id}'));

        final initialOffset = tester.getCenter(cardFinder);
        await tester.pumpAndSettle();
        final finalOffset = tester.getCenter(cardFinder);

        expect(
          initialOffset,
          isNot(equals(finalOffset)),
        );
      });

      testWidgets('completes when both players play a card', (tester) async {
        when(() => bloc.lastPlayedCardId).thenReturn(opponentCards.first.id);
        whenListen(
          bloc,
          Stream.fromIterable([
            baseState,
            baseState.copyWith(
              turns: [
                MatchTurn(
                  playerCardId: playerCards.first.id,
                  opponentCardId: opponentCards.first.id,
                )
              ],
            )
          ]),
          initialState: baseState,
        );

        await tester.pumpSubject(bloc);
        await tester.pumpAndSettle();

        await tester.pump(turnEndDuration);

        verify(() => bloc.add(CardOverlayRevealed())).called(1);
      });

      testWidgets(
        'completes and goes back when both players play a card',
        (tester) async {
          final lastPlayedCards = [
            () => playerCards.first.id,
            () => opponentCards.first.id
          ];
          when(() => bloc.lastPlayedCardId)
              .thenAnswer((_) => lastPlayedCards.removeAt(0)());

          whenListen(
            bloc,
            Stream.fromIterable([
              baseState,
              baseState.copyWith(
                turns: [
                  MatchTurn(
                    playerCardId: playerCards.first.id,
                    opponentCardId: null,
                  )
                ],
              ),
              baseState.copyWith(
                turns: [
                  MatchTurn(
                    playerCardId: playerCards.first.id,
                    opponentCardId: opponentCards.first.id,
                  )
                ],
              )
            ]),
            initialState: baseState,
          );
          await tester.pumpSubject(bloc);

          final playerCardFinder =
              find.byKey(Key('player_card_${playerCards.first.id}'));
          final opponentCardFinder =
              find.byKey(Key('opponent_card_${opponentCards.first.id}'));

          // Get card offset before moving
          final playerInitialOffset = tester.getCenter(playerCardFinder);
          final opponentInitialOffset = tester.getCenter(opponentCardFinder);

          // Get card offset after both players play and cards are in the clash
          // zone
          await tester.pumpAndSettle();
          final playerClashOffset = tester.getCenter(playerCardFinder);
          expect(playerInitialOffset, isNot(equals(playerClashOffset)));

          await tester.pumpAndSettle();
          final opponentClashOffset = tester.getCenter(opponentCardFinder);
          expect(opponentInitialOffset, isNot(equals(opponentClashOffset)));

          // Get card offset once clash is over and both cards are back in the
          // original position
          await tester.pump(turnEndDuration);
          await tester.pumpAndSettle();
          final playerFinalOffset = tester.getCenter(playerCardFinder);
          final opponentFinalOffset = tester.getCenter(opponentCardFinder);

          expect(playerInitialOffset, equals(playerFinalOffset));
          expect(opponentInitialOffset, equals(opponentFinalOffset));

          verify(() => bloc.add(CardOverlayRevealed())).called(2);
          verify(() => bloc.add(TurnAnimationsFinished())).called(2);
        },
      );
    });
  });
}

extension GameViewTest on WidgetTester {
  Future<void> pumpSubject(
    GameBloc bloc, {
    GoRouter? goRouter,
    LeaderboardResource? leaderboardResource,
  }) {
    return mockNetworkImages(() {
      return pumpApp(
        BlocProvider<GameBloc>.value(
          value: bloc,
          child: GameView(),
        ),
        router: goRouter,
        leaderboardResource: leaderboardResource,
      );
    });
  }
}
