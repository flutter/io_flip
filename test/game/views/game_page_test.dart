// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/game/game.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  group('GamePage', () {
    late GoRouterState goRouterState;
    const matchId = 'matchId';
    const deck = Deck(id: 'deckId', userId: 'userId', cards: []);
    final data = GamePageData(isHost: true, matchId: matchId, deck: deck);

    setUp(() {
      goRouterState = _MockGoRouterState();
      when(() => goRouterState.extra).thenReturn(data);
    });

    test('routeBuilder returns a GamePage', () {
      expect(
        GamePage.routeBuilder(null, goRouterState),
        isA<GamePage>()
            .having((page) => page.isHost, 'isHost', equals(data.isHost))
            .having((page) => page.matchId, 'matchId', equals(data.matchId))
            .having((page) => page.deck, 'deck', equals(data.deck)),
      );
    });

    testWidgets('renders a GameView', (tester) async {
      await tester.pumpApp(
        GamePage(
          matchId: 'matchId',
          isHost: false,
          deck: deck,
        ),
      );

      expect(find.byType(GameView), findsOneWidget);
    });
  });
}
