// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/game/game.dart';

import '../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  group('GameView', () {
    late GameBloc bloc;

    setUp(() {
      bloc = _MockGameBloc();
      when(() => bloc.isHost).thenReturn(true);
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

    // TODO(erickzanardo): expand this test.
    testWidgets('renders the game summary on success', (tester) async {
      mockState(
        MatchLoadedState(
          match: Match(
            id: '',
            hostDeck: Deck(
              id: '',
              cards: const [
                Card(
                  id: '',
                  name: 'host_card',
                  description: '',
                  image: '',
                  rarity: true,
                  power: 1,
                ),
              ],
            ),
            guestDeck: Deck(
              id: '',
              cards: const [
                Card(
                  id: '',
                  name: 'guest_card',
                  description: '',
                  image: '',
                  rarity: true,
                  power: 1,
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
          turns: const [],
        ),
      );
      await tester.pumpSubject(bloc);

      expect(find.byType(GameView), findsOneWidget);
    });
  });
}

extension MatchMakingViewTest on WidgetTester {
  Future<void> pumpSubject(GameBloc bloc) {
    return mockNetworkImages(() {
      return pumpApp(
        BlocProvider<GameBloc>.value(
          value: bloc,
          child: GameView(),
        ),
      );
    });
  }
}
