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

import '../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  group('GameView', () {
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
        playerPlayed: false,
      );

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
        'render the win badge on the player winning card',
        (tester) async {
          when(
            () => bloc.isWiningCard(
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
          ).thenReturn(true);

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

          expect(
            find.byKey(const Key('win_badge_player_card')),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'render the win badge on the opponent winning card',
        (tester) async {
          when(
            () => bloc.isWiningCard(
              Card(
                id: 'opponent_card',
                name: 'guest_card',
                description: '',
                image: '',
                rarity: true,
                power: 10,
                suit: Suit.air,
              ),
              isPlayer: false,
            ),
          ).thenReturn(true);

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
                )
              ],
            ),
          );
          await tester.pumpSubject(bloc);

          expect(
            find.byKey(const Key('win_badge_opponent_card')),
            findsOneWidget,
          );
        },
      );
    });
  });
}

extension GameViewTest on WidgetTester {
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
