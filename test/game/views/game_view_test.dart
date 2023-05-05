// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/leaderboard/leaderboard.dart';
import 'package:io_flip/settings/settings_controller.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockAudioController extends Mock implements AudioController {}

class _FakeGameState extends Fake implements GameState {}

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
      registerFallbackValue(_FakeGameState());
    });

    setUp(() {
      bloc = _MockGameBloc();
      when(() => bloc.isHost).thenReturn(true);
      when(() => bloc.isWinningCard(any(), isPlayer: any(named: 'isPlayer')))
          .thenReturn(null);
      when(() => bloc.canPlayerPlay(any())).thenReturn(true);
      when(() => bloc.isPlayerAllowedToPlay).thenReturn(true);
      when(() => bloc.matchCompleted(any())).thenReturn(false);

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

    testWidgets(
      'renders an error message when failed and navigates to main page',
      (tester) async {
        final goRouter = MockGoRouter();
        mockState(MatchLoadFailedState());
        await tester.pumpSubject(
          bloc,
          goRouter: goRouter,
        );

        expect(find.text('Unable to join game!'), findsOneWidget);

        await tester.tap(find.byType(RoundedButton));
        await tester.pumpAndSettle();

        verify(() => goRouter.go('/')).called(1);
      },
    );

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
        ),
        rounds: const [],
        turnTimeRemaining: 10,
        turnAnimationsFinished: true,
        isClashScene: false,
        showCardLanding: false,
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
            find.widgetWithText(RoundedButton, 'PLAY AGAIN'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'goes to main page when the replay button is tapped on opponent absent',
        (tester) async {
          final goRouter = MockGoRouter();

          mockState(OpponentAbsentState());

          await tester.pumpSubject(
            bloc,
            goRouter: goRouter,
          );

          await tester.tap(find.byType(RoundedButton));
          await tester.pumpAndSettle();

          verify(() => goRouter.go('/')).called(1);
        },
      );

      testWidgets(
        'plays a player card on tap',
        (tester) async {
          final audioController = _MockAudioController();
          mockState(baseState);
          await tester.pumpSubject(bloc, audioController: audioController);

          await tester.tap(find.byKey(const Key('player_card_player_card')));

          verify(() => audioController.playSfx(Assets.sfx.cardMovement))
              .called(1);

          verify(() => bloc.add(PlayerPlayed('player_card'))).called(1);
        },
      );

      testWidgets(
        "can't play a card that was already played",
        (tester) async {
          mockState(baseState);
          when(() => bloc.canPlayerPlay('player_card')).thenReturn(false);
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
              rounds: [
                MatchRound(
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
        'plays a player card when dragged',
        (tester) async {
          final audioController = _MockAudioController();
          mockState(baseState);
          await tester.pumpSubject(bloc, audioController: audioController);

          final start = tester
              .getCenter(find.byKey(const Key('player_card_player_card')));
          final end = tester.getCenter(find.byKey(const Key('clash_card_1')));

          await tester.dragFrom(start, end - start);
          await tester.pumpAndSettle();

          verify(() => audioController.playSfx(Assets.sfx.cardMovement))
              .called(1);

          verify(() => bloc.add(PlayerPlayed('player_card'))).called(1);
        },
      );

      testWidgets(
        'dragging a player card not to the correct spot does not play it',
        (tester) async {
          mockState(baseState);
          await tester.pumpSubject(bloc);

          final start = tester
              .getCenter(find.byKey(const Key('player_card_player_card')));
          final end = tester.getCenter(find.byKey(const Key('clash_card_0')));

          await tester.dragFrom(start, end - start);
          await tester.pumpAndSettle();

          verifyNever(() => bloc.add(PlayerPlayed('player_card')));
        },
      );

      testWidgets(
        'dragging a player card moves it with the pointer',
        (tester) async {
          mockState(baseState);
          await tester.pumpSubject(bloc);

          Rect getClashRect() =>
              tester.getRect(find.byKey(const Key('clash_card_1')));
          Offset getPlayerCenter() => tester.getCenter(
                find.byKey(const Key('player_card_player_card')),
              );

          final startClashRect = getClashRect();
          final start = getPlayerCenter();
          final end = getClashRect().center;
          final offset = end - start;
          final gesture = await tester.startGesture(start);
          await gesture.moveBy(Offset(kDragSlopDefault, -kDragSlopDefault));
          await gesture.moveBy(
            Offset(
              offset.dx - kDragSlopDefault,
              offset.dy + kDragSlopDefault,
            ),
          );

          await tester.pump();
          await tester.pump(const Duration(milliseconds: 200));

          expect(getClashRect().contains(getPlayerCenter()), isTrue);
          expect(getClashRect(), equals(startClashRect.inflate(8)));
        },
      );

      testWidgets(
        'render the opponent card instantly when played',
        (tester) async {
          mockState(
            baseState.copyWith(
              rounds: [
                MatchRound(
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
              rounds: [
                MatchRound(
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
              rounds: [
                MatchRound(
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
        ),
        rounds: const [],
        turnTimeRemaining: 10,
        turnAnimationsFinished: true,
        isClashScene: false,
        showCardLanding: false,
      );

      setUp(() {
        when(() => bloc.playerCards).thenReturn(playerCards);
        when(() => bloc.opponentCards).thenReturn(opponentCards);
        when(() => bloc.lastPlayedPlayerCard).thenReturn(playerCards.first);
        when(() => bloc.lastPlayedOpponentCard).thenReturn(opponentCards.first);
      });

      testWidgets('starts when player plays a card', (tester) async {
        whenListen(
          bloc,
          Stream.fromIterable([
            baseState,
            baseState.copyWith(
              lastPlayedCardId: playerCards.first.id,
              rounds: [
                MatchRound(
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
        whenListen(
          bloc,
          Stream.fromIterable([
            baseState,
            baseState.copyWith(
              lastPlayedCardId: opponentCards.first.id,
              rounds: [
                MatchRound(
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
        final controller = StreamController<GameState>();
        final playedState = baseState.copyWith(
          lastPlayedCardId: playerCards.first.id,
          rounds: [
            MatchRound(
              playerCardId: playerCards.first.id,
              opponentCardId: opponentCards.first.id,
            )
          ],
        );
        whenListen(
          bloc,
          controller.stream,
          initialState: baseState,
        );
        when(() => bloc.add(CardLandingStarted())).thenAnswer((_) {
          controller.add(playedState.copyWith(showCardLanding: true));
        });

        await tester.pumpSubject(bloc);
        controller
          ..add(baseState)
          ..add(playedState);

        await tester.pumpAndSettle();
        controller.add(playedState.copyWith(showCardLanding: false));
        await tester.pumpAndSettle();

        verify(() => bloc.add(ClashSceneStarted())).called(1);
      });

      testWidgets(
        'completes and goes back when both players play a card and '
        'clash scene finishes, plays round lost sfx',
        (tester) async {
          final controller = StreamController<GameState>.broadcast();
          final audioController = _MockAudioController();
          when(() => bloc.isWinningCard(playerCards.first, isPlayer: true))
              .thenReturn(CardOverlayType.lose);

          whenListen(
            bloc,
            controller.stream,
            initialState: baseState,
          );

          await tester.pumpSubject(bloc, audioController: audioController);

          final playerCardFinder =
              find.byKey(Key('player_card_${playerCards.first.id}'));
          final opponentCardFinder =
              find.byKey(Key('opponent_card_${opponentCards.first.id}'));

          // Get card offset before moving
          final playerInitialOffset = tester.getCenter(playerCardFinder);
          final opponentInitialOffset = tester.getCenter(opponentCardFinder);

          controller.add(
            baseState.copyWith(
              lastPlayedCardId: playerCards.first.id,
              rounds: [
                MatchRound(
                  playerCardId: playerCards.first.id,
                  opponentCardId: null,
                )
              ],
            ),
          );

          // Get card offset after both players play and cards are in the clash
          // zone
          await tester.pumpAndSettle();
          final playerClashOffset = tester.getCenter(playerCardFinder);
          expect(playerClashOffset, isNot(equals(playerInitialOffset)));

          controller.add(
            baseState.copyWith(
              lastPlayedCardId: opponentCards.first.id,
              rounds: [
                MatchRound(
                  playerCardId: playerCards.first.id,
                  opponentCardId: opponentCards.first.id,
                )
              ],
            ),
          );

          await tester.pump();
          await tester.pump();
          await tester.pump(Duration(milliseconds: 400));

          final opponentClashOffset = tester.getCenter(opponentCardFinder);
          expect(opponentClashOffset, isNot(equals(opponentInitialOffset)));

          controller.add(baseState.copyWith(isClashScene: true));

          await tester.pumpAndSettle();

          final clashScene = find.byType(ClashScene);
          expect(clashScene, findsOneWidget);
          tester.widget<ClashScene>(clashScene).onFinished();

          controller.add(baseState.copyWith(isClashScene: false));

          // Get card offset once clash is over and both cards are back in the
          // original position
          await tester.pump(turnEndDuration);
          await tester.pumpAndSettle();
          final playerFinalOffset = tester.getCenter(playerCardFinder);
          final opponentFinalOffset = tester.getCenter(opponentCardFinder);

          expect(playerFinalOffset, equals(playerInitialOffset));
          expect(opponentFinalOffset, equals(opponentInitialOffset));

          verify(() => audioController.playSfx(Assets.sfx.roundLost)).called(1);

          verify(() => bloc.add(ClashSceneStarted())).called(1);
          verify(() => bloc.add(ClashSceneCompleted())).called(1);
          verify(() => bloc.add(TurnAnimationsFinished())).called(1);
          verify(() => bloc.add(TurnTimerStarted())).called(1);
        },
      );

      testWidgets(
        'completes and goes back when both players play a card and '
        'clash scene finishes, plays round win sfx',
        (tester) async {
          final controller = StreamController<GameState>.broadcast();
          final audioController = _MockAudioController();

          when(() => bloc.isWinningCard(playerCards.first, isPlayer: true))
              .thenReturn(CardOverlayType.win);

          whenListen(
            bloc,
            controller.stream,
            initialState: baseState,
          );

          await tester.pumpSubject(bloc, audioController: audioController);

          final playerCardFinder =
              find.byKey(Key('player_card_${playerCards.first.id}'));
          final opponentCardFinder =
              find.byKey(Key('opponent_card_${opponentCards.first.id}'));

          // Get card offset before moving
          final playerInitialOffset = tester.getCenter(playerCardFinder);
          final opponentInitialOffset = tester.getCenter(opponentCardFinder);

          controller.add(
            baseState.copyWith(
              lastPlayedCardId: playerCards.first.id,
              rounds: [
                MatchRound(
                  playerCardId: playerCards.first.id,
                  opponentCardId: null,
                )
              ],
            ),
          );

          // Get card offset after both players play and cards are in the clash
          // zone
          await tester.pumpAndSettle();
          final playerClashOffset = tester.getCenter(playerCardFinder);
          expect(playerClashOffset, isNot(equals(playerInitialOffset)));

          controller.add(
            baseState.copyWith(
              lastPlayedCardId: opponentCards.first.id,
              rounds: [
                MatchRound(
                  playerCardId: playerCards.first.id,
                  opponentCardId: opponentCards.first.id,
                )
              ],
            ),
          );

          await tester.pump();
          await tester.pump();
          await tester.pump(Duration(milliseconds: 400));

          final opponentClashOffset = tester.getCenter(opponentCardFinder);
          expect(opponentClashOffset, isNot(equals(opponentInitialOffset)));

          controller.add(baseState.copyWith(isClashScene: true));

          await tester.pumpAndSettle();

          final clashScene = find.byType(ClashScene);
          expect(clashScene, findsOneWidget);
          tester.widget<ClashScene>(clashScene).onFinished();

          controller.add(baseState.copyWith(isClashScene: false));

          // Get card offset once clash is over and both cards are back in the
          // original position
          await tester.pump(turnEndDuration);
          await tester.pumpAndSettle();
          final playerFinalOffset = tester.getCenter(playerCardFinder);
          final opponentFinalOffset = tester.getCenter(opponentCardFinder);

          expect(playerFinalOffset, equals(playerInitialOffset));
          expect(opponentFinalOffset, equals(opponentInitialOffset));

          verify(() => audioController.playSfx(Assets.sfx.roundWin)).called(1);

          verify(() => bloc.add(ClashSceneStarted())).called(1);
          verify(() => bloc.add(ClashSceneCompleted())).called(1);
          verify(() => bloc.add(TurnAnimationsFinished())).called(1);
          verify(() => bloc.add(TurnTimerStarted())).called(1);
        },
      );

      testWidgets(
        'completes and shows card landing puff effect when player plays a card',
        (tester) async {
          whenListen(
            bloc,
            Stream.fromIterable([
              baseState,
              baseState.copyWith(
                lastPlayedCardId: playerCards.first.id,
                rounds: [
                  MatchRound(
                    playerCardId: playerCards.first.id,
                    opponentCardId: null,
                  ),
                ],
                showCardLanding: true,
              ),
            ]),
            initialState: baseState,
          );

          await tester.pumpSubject(bloc);
          await tester.pump(bigFlipAnimation.duration);

          final cardLandingPuff = find.byType(CardLandingPuff);
          expect(cardLandingPuff, findsOneWidget);

          await tester.pumpAndSettle(
            bigFlipAnimation.duration + CardLandingPuff.duration,
          );

          tester.widget<CardLandingPuff>(cardLandingPuff).onComplete?.call();

          verify(() => bloc.add(CardLandingStarted())).called(1);
          verify(() => bloc.add(CardLandingCompleted())).called(1);
        },
      );
    });
  });

  group('CrossPainter', () {
    test('shouldRepaint always returns false', () {
      final painter = CrossPainter();
      expect(painter.shouldRepaint(CrossPainter()), isFalse);
    });
  });
}

extension GameViewTest on WidgetTester {
  Future<void> pumpSubject(
    GameBloc bloc, {
    GoRouter? goRouter,
    LeaderboardResource? leaderboardResource,
    AudioController? audioController,
  }) {
    final SettingsController settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    return mockNetworkImages(() {
      return pumpApp(
        BlocProvider<GameBloc>.value(
          value: bloc,
          child: GameView(),
        ),
        router: goRouter,
        settingsController: settingsController,
        leaderboardResource: leaderboardResource,
        audioController: audioController,
      );
    });
  }
}
