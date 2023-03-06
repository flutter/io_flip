// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/game/game.dart';

import '../../helpers/pump_app.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockGameClient extends Mock implements GameClient {}

void main() {
  group('GamePage', () {
    late GoRouterState goRouterState;
    const matchId = 'matchId';

    setUp(() {
      goRouterState = _MockGoRouterState();
      when(() => goRouterState.params).thenReturn({
        'matchId': matchId,
      });
    });

    test('routeBuilder returns a GamePage', () {
      expect(
        GamePage.routeBuilder(null, goRouterState),
        isA<GamePage>(),
      );
    });

    testWidgets('renders a GameView', (tester) async {
      await tester.pumpSubject();
      expect(find.byType(GameView), findsOneWidget);
    });
  });
}

extension MatchMakingPageTest on WidgetTester {
  Future<void> pumpSubject() {
    return pumpApp(
      MultiProvider(
        providers: [
          Provider<GameClient>(create: (_) => _MockGameClient()),
        ],
        child: GamePage(
          matchId: 'matchId',
        ),
      ),
    );
  }
}
