// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/game/views/game_summary.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/share/views/share_hand_page.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockGameBloc extends Mock implements GameBloc {}

abstract class __Router {
  void neglect(BuildContext context, VoidCallback callback);
}

class _MockRouter extends Mock implements __Router {}

class _MockBuildContext extends Mock implements BuildContext {}

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
    });

    setUp(() {
      bloc = _MockGameBloc();
      when(() => bloc.isHost).thenReturn(true);
      when(() => bloc.isWinningCard(any(), isPlayer: any(named: 'isPlayer')))
          .thenReturn(null);
      when(() => bloc.canPlayerPlay(any())).thenReturn(true);
      when(() => bloc.isPlayerAllowedToPlay).thenReturn(true);
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
      isFightScene: false,
      showCardLanding: false,
    );

    void defaultMockState({
      ScoreCard? scoreCard,
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
            result: MatchResult.guest,
          ),
          turnAnimationsFinished: true,
        ),
      );
    }

    group('Gameplay', () {
      testWidgets(
        'renders in small phone layout',
        (tester) async {
          tester.setSmallestPhoneDisplaySize();
          defaultMockState();
          when(bloc.gameResult).thenReturn(GameResult.draw);
          await tester.pumpSubject(bloc);

          expect(
            find.byType(GameSummaryView),
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
          await tester.pumpAndSettle();
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
          await tester.pumpAndSettle();

          verify(
            () => goRouter.pushNamed(
              'card_inspector',
              extra: any(named: 'extra'),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'pops navigation when the next match button is tapped',
        (tester) async {
          final goRouter = MockGoRouter();

          defaultMockState();
          await tester.pumpSubject(
            bloc,
            goRouter: goRouter,
          );

          await tester.tap(find.text(tester.l10n.nextMatch));
          await tester.pumpAndSettle();

          verify(goRouter.pop).called(1);
        },
      );

      testWidgets(
        'pops navigation when the quit button is tapped and canceled',
        (tester) async {
          final goRouter = MockGoRouter();

          defaultMockState();
          await tester.pumpSubject(
            bloc,
            goRouter: goRouter,
          );

          await tester.tap(find.text(tester.l10n.quit));
          await tester.pumpAndSettle();

          expect(find.byType(QuitGameDialog), findsOneWidget);

          await tester.tap(find.text(tester.l10n.cancel));
          await tester.pumpAndSettle();

          verify(goRouter.pop).called(1);
        },
      );
    });

    group('GameSummaryFooter', () {
      late __Router router;

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
        'pops navigation when the quit button is tapped and confirmed and '
        'adds LeaderboardEntryRequested event to bloc if player score card '
        'initials is null',
        (tester) async {
          final goRouter = MockGoRouter();
          when(() => bloc.playerCards).thenReturn([]);
          defaultMockState();

          await tester.pumpApp(
            BlocProvider<GameBloc>.value(
              value: bloc,
              child: GameSummaryFooter(
                isPhoneWidth: false,
                routerNeglectCall: router.neglect,
              ),
            ),
            router: goRouter,
          );

          await tester.tap(find.text(tester.l10n.quit));
          await tester.pumpAndSettle();

          expect(find.byType(QuitGameDialog), findsOneWidget);

          await tester.tap(find.text(tester.l10n.quit).last);
          await tester.pumpAndSettle();

          verify(goRouter.pop).called(1);
          verify(
            () => bloc.add(
              LeaderboardEntryRequested(
                shareHandPageData: ShareHandPageData(
                  initials: '',
                  deck: const [],
                  deckId: '',
                  wins: 0,
                ),
              ),
            ),
          ).called(1);
        },
      );

      testWidgets(
        'routes to share hand page when the quit button is tapped '
        'and confirmed and player score card has initials',
        (tester) async {
          final goRouter = MockGoRouter();

          when(() => bloc.playerCards).thenReturn([]);

          defaultMockState(
            scoreCard: ScoreCard(id: 'id', initials: 'AAA'),
          );

          await tester.pumpApp(
            BlocProvider<GameBloc>.value(
              value: bloc,
              child: GameSummaryFooter(
                isPhoneWidth: false,
                routerNeglectCall: router.neglect,
              ),
            ),
            router: goRouter,
          );

          await tester.tap(find.text(tester.l10n.quit));
          await tester.pumpAndSettle();

          expect(find.byType(QuitGameDialog), findsOneWidget);

          await tester.tap(find.text(tester.l10n.quit).last);
          await tester.pumpAndSettle();

          verify(
            () => goRouter.goNamed(
              'share_hand',
              extra: ShareHandPageData(
                initials: 'AAA',
                wins: 0,
                deckId: '',
                deck: const [],
              ),
            ),
          ).called(1);
        },
      );
    });
  });
}

extension GameSummaryViewTest on WidgetTester {
  Future<void> pumpSubject(
    GameBloc bloc, {
    GoRouter? goRouter,
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
      );
      state<MatchResultSplashState>(
        find.byType(MatchResultSplash),
      ).onComplete();
      await pump();
    });
  }
}
