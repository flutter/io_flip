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
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

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

    final baseState = MatchLoadedState(
      playerScoreCard: ScoreCard(id: 'scoreCardId'),
      match: Match(
        id: '',
        hostDeck: Deck(
          id: '',
          userId: '',
          cards: const [
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
          ],
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
            guestPlayedCards: const [],
            hostPlayedCards: const [],
            result: MatchResult.guest,
          ),
          turnAnimationsFinished: true,
        ),
      );
    }

    group('Gameplay', () {
      testWidgets(
        'renders the draw message when the players make a draw',
        (tester) async {
          mockState(
            baseState.copyWith(
              matchState: MatchState(
                id: '',
                matchId: '',
                guestPlayedCards: const [],
                hostPlayedCards: const [],
                result: MatchResult.draw,
              ),
              turnAnimationsFinished: true,
            ),
          );
          await tester.pumpSubject(bloc);

          expect(
            find.text(tester.l10n.gameTiedTitle),
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
                guestPlayedCards: const [],
                hostPlayedCards: const [],
                result: MatchResult.host,
              ),
              turnAnimationsFinished: true,
            ),
          );
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
                result: MatchResult.guest,
              ),
              turnAnimationsFinished: true,
            ),
          );
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

      testWidgets('renders the game summary in landscape', (tester) async {
        tester.setLandscapeDisplaySize();
        defaultMockState();

        await tester.pumpSubject(bloc);

        expect(find.byType(GameSummaryView), findsOneWidget);
        expect(find.byType(LandscapeSummaryView), findsOneWidget);
      });

      testWidgets('renders the game summary in portrait', (tester) async {
        tester.setPortraitDisplaySize();
        defaultMockState();

        await tester.pumpSubject(bloc);

        expect(find.byType(GameSummaryView), findsOneWidget);
        expect(find.byType(PortraitSummaryView), findsOneWidget);
      });

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

      testWidgets(
        'pops navigation when the quit button is tapped and canceled '
        'by close icon',
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

          await tester.tap(find.byIcon(Icons.close));
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

          await tester.tap(find.text(tester.l10n.quit));
          await tester.pumpAndSettle();

          expect(find.byType(QuitGameDialog), findsOneWidget);

          await tester.tap(find.text(tester.l10n.quit).last);
          await tester.pumpAndSettle();

          verify(goRouter.pop).called(1);
          verify(() => bloc.add(LeaderboardEntryRequested())).called(1);
        },
      );

      testWidgets(
        'pops navigation when the quit button is tapped and confirmed and '
        'player score card has initials',
        (tester) async {
          final goRouter = MockGoRouter();

          defaultMockState(
            scoreCard: ScoreCard(id: 'id', initials: 'AAA'),
          );

          await tester.pumpApp(
            BlocProvider<GameBloc>.value(
              value: bloc,
              child: GameSummaryFooter(
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

          verify(() => goRouter.go('/')).called(1);
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
    return mockNetworkImages(() {
      return pumpApp(
        BlocProvider<GameBloc>.value(
          value: bloc,
          child: GameView(),
        ),
        router: goRouter,
      );
    });
  }
}
