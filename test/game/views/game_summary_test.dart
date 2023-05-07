// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:io_flip/share/views/card_inspector_dialog.dart';
import 'package:io_flip/share/views/share_hand_page.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockRouter extends Mock implements NeglectRouter {}

class _MockBuildContext extends Mock implements BuildContext {}

class _MockAudioController extends Mock implements AudioController {}

class _FakeGameState extends Fake implements GameState {}

void main() {
  group('GameSummaryView', () {
    late GameBloc bloc;

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
      registerFallbackValue(LeaderboardEntryRequested());
      registerFallbackValue(_FakeGameState());
    });

    setUp(() {
      bloc = _MockGameBloc();
      when(() => bloc.isHost).thenReturn(true);
      when(() => bloc.isWinningCard(any(), isPlayer: any(named: 'isPlayer')))
          .thenReturn(null);
      when(() => bloc.canPlayerPlay(any())).thenReturn(true);
      when(() => bloc.isPlayerAllowedToPlay).thenReturn(true);
      when(() => bloc.matchCompleted(any())).thenReturn(true);
    });

    void mockState(GameState state) {
      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );
    }

    const cards = [
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
        suit: Suit.earth,
      ),
      Card(
        id: 'player_card_3',
        name: 'host_card_3',
        description: '',
        image: '',
        rarity: true,
        power: 4,
        suit: Suit.metal,
      ),
    ];

    final baseState = MatchLoadedState(
      playerScoreCard: ScoreCard(id: 'scoreCardId'),
      match: Match(
        id: '',
        hostDeck: Deck(
          id: '',
          userId: '',
          cards: cards,
        ),
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
              power: 1,
              suit: Suit.fire,
            ),
            Card(
              id: 'opponent_card_2',
              name: 'guest_card_2',
              description: '',
              image: '',
              rarity: false,
              power: 1,
              suit: Suit.air,
            ),
            Card(
              id: 'opponent_card_3',
              name: 'guest_card_3',
              description: '',
              image: '',
              rarity: false,
              power: 10,
              suit: Suit.water,
            ),
          ],
        ),
      ),
      matchState: MatchState(
        id: '',
        matchId: '',
        guestPlayedCards: const [],
        hostPlayedCards: const [],
      ),
      rounds: const [],
      turnTimeRemaining: 10,
      turnAnimationsFinished: false,
      isClashScene: false,
      showCardLanding: false,
    );

    void defaultMockState({
      ScoreCard? scoreCard,
      MatchResult matchResult = MatchResult.guest,
    }) {
      mockState(
        baseState.copyWith(
          playerScoreCard: scoreCard,
          matchState: MatchState(
            id: '',
            matchId: '',
            guestPlayedCards: const [
              'opponent_card_2',
              'opponent_card_3',
              'opponent_card'
            ],
            hostPlayedCards: const [
              'player_card_2',
              'player_card',
              'player_card_3',
            ],
            result: matchResult,
          ),
          turnAnimationsFinished: true,
        ),
      );
    }

    group('Gameplay', () {
      testWidgets('Play lostMatch sound when the player loses the game',
          (tester) async {
        final audioController = _MockAudioController();
        defaultMockState();
        when(bloc.gameResult).thenReturn(GameResult.lose);
        await tester.pumpSubject(bloc, audioController: audioController);
        await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

        verify(() => audioController.playSfx(Assets.sfx.lostMatch)).called(1);
      });

      testWidgets('Play winMatch sound when the player wins the game',
          (tester) async {
        final audioController = _MockAudioController();
        defaultMockState();
        when(bloc.gameResult).thenReturn(GameResult.win);
        await tester.pumpSubject(bloc, audioController: audioController);
        await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

        verify(() => audioController.playSfx(Assets.sfx.winMatch)).called(1);
      });

      testWidgets('Play drawMatch sound when there is a draw', (tester) async {
        final audioController = _MockAudioController();
        defaultMockState();
        when(bloc.gameResult).thenReturn(GameResult.draw);
        await tester.pumpSubject(bloc, audioController: audioController);
        await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

        verify(() => audioController.playSfx(Assets.sfx.drawMatch)).called(1);
      });

      testWidgets(
        'renders in small phone layout',
        (tester) async {
          tester.setSmallestPhoneDisplaySize();
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.draw);
          await tester.pumpSubject(bloc);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          expect(
            find.byType(GameSummaryView),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders win splash on small phone layout',
        (tester) async {
          tester.setSmallestPhoneDisplaySize();
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.win);
          final SettingsController settingsController =
              _MockSettingsController();
          when(() => settingsController.muted).thenReturn(ValueNotifier(true));
          await mockNetworkImages(() async {
            await tester.pumpApp(
              BlocProvider<GameBloc>.value(
                value: bloc,
                child: GameSummaryView(isWeb: true),
              ),
              settingsController: settingsController,
            );
          });

          expect(
            find.byKey(Key('matchResultSplash_win_mobile')),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders loss splash on small phone layout',
        (tester) async {
          tester.setSmallestPhoneDisplaySize();
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.lose);
          final SettingsController settingsController =
              _MockSettingsController();
          when(() => settingsController.muted).thenReturn(ValueNotifier(true));
          await mockNetworkImages(() async {
            await tester.pumpApp(
              BlocProvider<GameBloc>.value(
                value: bloc,
                child: GameSummaryView(isWeb: true),
              ),
              settingsController: settingsController,
            );
          });

          expect(
            find.byKey(Key('matchResultSplash_loss_mobile')),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders draw splash on small phone layout',
        (tester) async {
          tester.setSmallestPhoneDisplaySize();
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.draw);
          final SettingsController settingsController =
              _MockSettingsController();
          when(() => settingsController.muted).thenReturn(ValueNotifier(true));
          await mockNetworkImages(() async {
            await tester.pumpApp(
              BlocProvider<GameBloc>.value(
                value: bloc,
                child: GameSummaryView(isWeb: true),
              ),
              settingsController: settingsController,
            );
          });

          expect(
            find.byKey(Key('matchResultSplash_draw_mobile')),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders in large phone layout',
        (tester) async {
          tester.setLargePhoneDisplaySize();
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.draw);
          await tester.pumpSubject(bloc);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          expect(
            find.byType(GameSummaryView),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'renders the draw message when the players make a draw',
        (tester) async {
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.draw);
          await tester.pumpSubject(bloc);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          expect(
            find.text(tester.l10n.gameTiedTitle),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders the logo message only when the screen is big enough',
        (tester) async {
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.lose);

          await tester.pumpSubject(bloc);

          expect(
            find.byType(IoFlipLogo),
            findsNothing,
          );

          tester.setLandscapeDisplaySize();
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);
          expect(
            find.byType(IoFlipLogo),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders the win message when the player won',
        (tester) async {
          mockState(
            baseState.copyWith(
              matchState: MatchState(
                id: '',
                matchId: '',
                guestPlayedCards: const [
                  'opponent_card_2',
                  'opponent_card_3',
                  'opponent_card'
                ],
                hostPlayedCards: const [
                  'player_card_2',
                  'player_card',
                  'player_card_3',
                ],
                result: MatchResult.host,
              ),
              turnAnimationsFinished: true,
            ),
          );
          when(bloc.gameResult).thenReturn(GameResult.win);
          await tester.pumpSubject(bloc);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          expect(
            find.text(tester.l10n.gameWonTitle),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders the lose message when the player lost',
        (tester) async {
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.lose);

          await tester.pumpSubject(bloc);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          expect(
            find.text(tester.l10n.gameLostTitle),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders all 6 cards with overlay, 3 for player and 3 for opponent',
        (tester) async {
          when(
            () => bloc.isWinningCard(any(), isPlayer: any(named: 'isPlayer')),
          ).thenReturn(CardOverlayType.win);
          when(() => bloc.isHost).thenReturn(false);
          defaultMockState();
          await tester.pumpSubject(bloc);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          expect(
            find.byType(GameCard),
            findsNWidgets(6),
          );

          expect(
            find.byType(CardOverlay),
            findsNWidgets(6),
          );
        },
      );

      testWidgets(
        'Renders correct score messages',
        (tester) async {
          when(
            () =>
                bloc.isWinningCard(cards[0], isPlayer: any(named: 'isPlayer')),
          ).thenReturn(CardOverlayType.win);
          when(
            () =>
                bloc.isWinningCard(cards[1], isPlayer: any(named: 'isPlayer')),
          ).thenReturn(CardOverlayType.lose);
          when(
            () =>
                bloc.isWinningCard(cards[2], isPlayer: any(named: 'isPlayer')),
          ).thenReturn(CardOverlayType.draw);
          when(() => bloc.isHost).thenReturn(true);
          defaultMockState();
          await tester.pumpSubject(bloc);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          expect(find.textContaining('W'), findsOneWidget);
          expect(find.textContaining('D'), findsOneWidget);
          expect(find.textContaining('L'), findsOneWidget);
        },
      );

      testWidgets(
        'navigates to inspector page when card is tapped',
        (tester) async {
          final goRouter = MockGoRouter();
          when(
            () => goRouter.pushNamed(
              'card_inspector',
              extra: any(named: 'extra'),
            ),
          ).thenAnswer((_) async {
            return;
          });
          when(
            () => bloc.isWinningCard(any(), isPlayer: any(named: 'isPlayer')),
          ).thenReturn(CardOverlayType.win);
          when(() => bloc.isHost).thenReturn(false);
          defaultMockState();
          await tester.pumpSubject(bloc, goRouter: goRouter);
          await tester.tap(find.byType(GameCard).first);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          expect(find.byType(CardInspectorDialog), findsOneWidget);
        },
      );
    });

    group('GameSummaryFooter', () {
      late NeglectRouter router;

      setUpAll(() {
        registerFallbackValue(_MockBuildContext());
      });

      setUp(() {
        router = _MockRouter();
        when(() => router.neglect(any(), any())).thenAnswer((_) {
          final callback = _.positionalArguments[1] as VoidCallback;
          callback();
        });
      });

      testWidgets(
        'navigates to matchmaking when the next match button is tapped',
        (tester) async {
          final goRouter = MockGoRouter();
          when(() => bloc.playerCards).thenReturn([]);
          when(() => bloc.playerDeck)
              .thenReturn(Deck(id: 'id', userId: 'userId', cards: cards));
          when(() => bloc.isHost).thenReturn(false);
          defaultMockState();

          await tester.pumpApp(
            BlocProvider<GameBloc>.value(
              value: bloc,
              child: GameSummaryFooter(
                routerNeglectCall: router.neglect,
              ),
            ),
            router: goRouter,
          );

          await tester.tap(find.text(tester.l10n.nextMatch));
          await tester.pumpAndSettle();

          verifyNever(() => bloc.sendMatchLeft());
          verify(
            () => goRouter.goNamed(
              'match_making',
              extra: any(named: 'extra'),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'navigates to matchmaking when the next match button is tapped '
        'if there is a draw',
        (tester) async {
          final goRouter = MockGoRouter();
          when(() => bloc.playerCards).thenReturn([]);
          when(() => bloc.playerDeck)
              .thenReturn(Deck(id: 'id', userId: 'userId', cards: cards));
          defaultMockState(matchResult: MatchResult.draw);

          await tester.pumpApp(
            BlocProvider<GameBloc>.value(
              value: bloc,
              child: GameSummaryFooter(
                routerNeglectCall: router.neglect,
              ),
            ),
            router: goRouter,
          );

          await tester.tap(find.text(tester.l10n.nextMatch));
          await tester.pumpAndSettle();

          verifyNever(() => bloc.sendMatchLeft());
          verify(
            () => goRouter.goNamed(
              'match_making',
              extra: any(named: 'extra'),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'pops navigation when the submit score button is tapped and canceled',
        (tester) async {
          when(() => bloc.isHost).thenReturn(false);
          when(() => bloc.playerCards).thenReturn([]);
          defaultMockState();
          await tester.pumpSubjectWithRouter(bloc);
          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);

          await tester.tap(find.text(tester.l10n.submitScore));
          await tester.pumpAndSettle();

          expect(find.byType(QuitGameDialog), findsOneWidget);

          await tester.tap(find.text(tester.l10n.cancel));
          await tester.pumpAndSettle();

          expect(find.byType(QuitGameDialog), findsNothing);
        },
      );

      testWidgets(
        'pops navigation when the submit score button is tapped by winner '
        'and confirmed and adds LeaderboardEntryRequested event to bloc',
        (tester) async {
          final goRouter = MockGoRouter();
          when(() => bloc.isHost).thenReturn(false);
          when(() => bloc.playerCards).thenReturn([]);
          defaultMockState();

          await tester.pumpApp(
            BlocProvider<GameBloc>.value(
              value: bloc,
              child: GameSummaryFooter(
                routerNeglectCall: router.neglect,
              ),
            ),
            router: goRouter,
          );

          await tester.tap(find.text(tester.l10n.submitScore));
          await tester.pumpAndSettle();

          expect(find.byType(QuitGameDialog), findsOneWidget);

          await tester.tap(find.text(tester.l10n.continueLabel));
          await tester.pumpAndSettle();

          verify(goRouter.pop).called(1);
          verify(
            () => bloc.add(
              LeaderboardEntryRequested(
                shareHandPageData: ShareHandPageData(
                  initials: '',
                  deck: baseState.match.guestDeck,
                  wins: 0,
                ),
              ),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'adds LeaderboardEntryRequested event to bloc when submit score button '
        'is tapped by loser',
        (tester) async {
          final goRouter = MockGoRouter();
          when(() => bloc.playerCards).thenReturn([]);
          defaultMockState();

          await tester.pumpApp(
            BlocProvider<GameBloc>.value(
              value: bloc,
              child: GameSummaryFooter(
                routerNeglectCall: router.neglect,
              ),
            ),
            router: goRouter,
          );

          await tester.tap(find.text(tester.l10n.submitScore));
          await tester.pumpAndSettle();

          verify(
            () => bloc.add(
              LeaderboardEntryRequested(
                shareHandPageData: ShareHandPageData(
                  initials: '',
                  deck: baseState.match.hostDeck,
                  wins: 0,
                ),
              ),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'pops snackbar when duration ends',
        (tester) async {
          when(() => bloc.isHost).thenReturn(false);
          when(() => bloc.playerCards).thenReturn([]);
          defaultMockState();
          await tester.pumpSubjectWithRouter(bloc);
          await tester.pumpAndSettle();

          expect(find.text(tester.l10n.cardInspectorText), findsOneWidget);

          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);
          expect(find.text(tester.l10n.cardInspectorText), findsNothing);
        },
      );

      testWidgets(
        'pops snackbar when tapping',
        (tester) async {
          when(() => bloc.isHost).thenReturn(false);
          when(() => bloc.playerCards).thenReturn([]);
          defaultMockState();
          await tester.pumpSubjectWithRouter(bloc);
          await tester.pumpAndSettle();

          expect(find.text(tester.l10n.cardInspectorText), findsOneWidget);

          await tester.tapAt(Offset.zero);
          await tester.pumpAndSettle();
          expect(find.text(tester.l10n.cardInspectorText), findsNothing);

          await tester.pumpAndSettle(GameSummaryView.cardInspectorDuration);
        },
      );
    });
  });
}

extension GameSummaryViewTest on WidgetTester {
  Future<void> pumpSubject(
    GameBloc bloc, {
    GoRouter? goRouter,
    AudioController? audioController,
  }) {
    final SettingsController settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    return mockNetworkImages(() async {
      await pumpApp(
        BlocProvider<GameBloc>.value(
          value: bloc,
          child: GameView(),
        ),
        router: goRouter,
        settingsController: settingsController,
        audioController: audioController,
      );
      state<MatchResultSplashState>(
        find.byType(MatchResultSplash),
      ).onComplete();
      await pump();
    });
  }

  Future<void> pumpSubjectWithRouter(
    GameBloc bloc, {
    AudioController? audioController,
  }) {
    final SettingsController settingsController = _MockSettingsController();
    final goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) {
            return BlocProvider<GameBloc>.value(
              value: bloc,
              child: GameSummaryView(),
            );
          },
        ),
      ],
    );

    when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    return mockNetworkImages(() async {
      await pumpAppWithRouter(
        goRouter,
        settingsController: settingsController,
        audioController: audioController,
      );
      state<MatchResultSplashState>(
        find.byType(MatchResultSplash),
      ).onComplete();
      await pump();
    });
  }
}
