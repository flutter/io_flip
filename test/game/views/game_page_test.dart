// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/game/game.dart';

import '../../helpers/pump_app.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockGameClient extends Mock implements GameClient {}

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockMatchSolver extends Mock implements MatchSolver {}

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

extension GamePageTest on WidgetTester {
  Future<void> pumpSubject() {
    return pumpApp(
      MultiProvider(
        providers: [
          Provider<GameClient>(create: (_) => _MockGameClient()),
          Provider<MatchMakerRepository>(
            create: (_) => _MockMatchMakerRepository(),
          ),
          Provider<MatchSolver>(
            create: (_) => _MockMatchSolver(),
          ),
        ],
        child: GamePage(
          matchId: 'matchId',
          isHost: false,
        ),
      ),
    );
  }
}
