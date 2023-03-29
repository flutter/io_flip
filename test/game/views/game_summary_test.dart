// ignore_for_file: prefer_const_constructors

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
      when(() => bloc.isWiningCard(any(), isPlayer: any(named: 'isPlayer')))
          .thenReturn(false);
      when(() => bloc.canPlayerPlay(any())).thenReturn(true);
      when(() => bloc.isPlayerTurn).thenReturn(true);
      when(bloc.hasPlayerWon).thenReturn(false);
    });

    void mockState(GameState state) {
      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );
    }

    group('Gameplay', () {
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
                suit: Suit.air,
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
                suit: Suit.air,
              ),
            ],
          ),
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
        playerPlayed: false,
      );

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
                hostStartsMatch: true,
                result: MatchResult.draw,
              ),
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
                hostStartsMatch: true,
                result: MatchResult.host,
              ),
            ),
          );
          when(bloc.hasPlayerWon).thenReturn(true);
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
          mockState(
            baseState.copyWith(
              matchState: MatchState(
                id: '',
                matchId: '',
                guestPlayedCards: const [],
                hostPlayedCards: const [],
                hostStartsMatch: true,
                result: MatchResult.guest,
              ),
            ),
          );
          when(bloc.hasPlayerWon).thenReturn(false);
          await tester.pumpSubject(bloc);

          expect(
            find.text(tester.l10n.gameLostTitle),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders cards',
        (tester) async {
          when(() => bloc.isHost).thenReturn(false);
          mockState(
            baseState.copyWith(
              matchState: MatchState(
                id: '',
                matchId: '',
                guestPlayedCards: const [],
                hostPlayedCards: const [],
                hostStartsMatch: true,
                result: MatchResult.guest,
              ),
            ),
          );
          await tester.pumpSubject(bloc);

          expect(
            find.byType(GameCard),
            findsNWidgets(3),
          );
        },
      );

      testWidgets('renders the game summary in landscape', (tester) async {
        tester.binding.window.devicePixelRatioTestValue = 1;
        mockState(
          baseState.copyWith(
            matchState: MatchState(
              id: '',
              matchId: '',
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
              result: MatchResult.guest,
            ),
          ),
        );

        await tester.pumpSubject(bloc);

        tester.binding.window.clearDevicePixelRatioTestValue();

        expect(find.byType(GameSummaryView), findsOneWidget);
        expect(find.byType(LandscapeSummaryView), findsOneWidget);
      });

      testWidgets('renders the game summary in portrait', (tester) async {
        tester.binding.window.devicePixelRatioTestValue = 1;
        tester.binding.window.physicalSizeTestValue = const Size(1200, 1600);
        mockState(
          baseState.copyWith(
            matchState: MatchState(
              id: '',
              matchId: '',
              guestPlayedCards: const [],
              hostPlayedCards: const [],
              hostStartsMatch: true,
              result: MatchResult.guest,
            ),
          ),
        );

        await tester.pumpSubject(bloc);

        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();

        expect(find.byType(GameSummaryView), findsOneWidget);
        expect(find.byType(PortraitSummaryView), findsOneWidget);
      });

      testWidgets(
        'pops navigation when the next match button is tapped',
        (tester) async {
          final goRouter = MockGoRouter();

          mockState(
            baseState.copyWith(
              matchState: MatchState(
                id: '',
                matchId: '',
                guestPlayedCards: const [],
                hostPlayedCards: const [],
                hostStartsMatch: true,
                result: MatchResult.guest,
              ),
            ),
          );
          when(bloc.hasPlayerWon).thenReturn(true);
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
        'pops navigation when the replay button is tapped',
        (tester) async {
          final goRouter = MockGoRouter();

          mockState(
            baseState.copyWith(
              matchState: MatchState(
                id: '',
                matchId: '',
                guestPlayedCards: const [],
                hostPlayedCards: const [],
                hostStartsMatch: true,
                result: MatchResult.guest,
              ),
            ),
          );
          when(bloc.hasPlayerWon).thenReturn(true);
          await tester.pumpSubject(
            bloc,
            goRouter: goRouter,
          );

          await tester.tap(find.text(tester.l10n.quit));
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
