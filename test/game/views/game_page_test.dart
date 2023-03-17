// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/game/game.dart';

import '../../helpers/pump_app.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

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
      await tester.pumpApp(
        GamePage(
          matchId: 'matchId',
          isHost: false,
        ),
      );

      expect(find.byType(GameView), findsOneWidget);
    });
  });
}
