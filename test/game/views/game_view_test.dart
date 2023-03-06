// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/game/game.dart';

import '../../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

class _UnknowState extends GameState {
  @override
  List<Object> get props => const [];
}

void main() {
  group('GameView', () {
    late GameBloc bloc;

    setUp(() {
      bloc = _MockGameBloc();
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

    testWidgets('renders the game summary on success', (tester) async {
      mockState(
        MatchLoadedState(
          Match(
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
        ),
      );
      await tester.pumpSubject(bloc);

      expect(find.text('host_card'), findsOneWidget);
      expect(find.text('guest_card'), findsOneWidget);
    });

    testWidgets('renders empty when on an unknow', (tester) async {
      mockState(_UnknowState());
      await tester.pumpSubject(bloc);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

extension MatchMakingViewTest on WidgetTester {
  Future<void> pumpSubject(GameBloc bloc) {
    return pumpApp(
      BlocProvider<GameBloc>.value(
        value: bloc,
        child: GameView(),
      ),
    );
  }
}
