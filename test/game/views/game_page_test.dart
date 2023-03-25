// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/game/game.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../helpers/pump_app.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockWebSocket extends Mock implements WebSocket {}

void main() {
  group('GamePage', () {
    late GoRouterState goRouterState;
    late WebSocket webSocket;
    const matchId = 'matchId';
    final data =
        GamePageData(isHost: true, matchConnection: null, matchId: matchId);

    setUp(() {
      goRouterState = _MockGoRouterState();
      webSocket = _MockWebSocket();
      when(() => goRouterState.extra).thenReturn(data);
    });

    test('routeBuilder returns a GamePage', () {
      expect(
        GamePage.routeBuilder(null, goRouterState),
        isA<GamePage>()
            .having((page) => page.isHost, 'isHost', equals(data.isHost))
            .having(
              (page) => page.matchConnection,
              'matchConnection',
              equals(data.matchConnection),
            )
            .having((page) => page.matchId, 'matchId', equals(data.matchId)),
      );
    });

    testWidgets('renders a GameView', (tester) async {
      await tester.pumpApp(
        GamePage(
          matchId: 'matchId',
          isHost: false,
          matchConnection: webSocket,
        ),
      );

      expect(find.byType(GameView), findsOneWidget);
    });
  });
}
