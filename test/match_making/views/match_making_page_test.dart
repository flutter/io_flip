// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/match_making/match_making.dart';

import '../../helpers/helpers.dart';

class _MockMatchMaker extends Mock implements MatchMaker {}

class _MockGameClient extends Mock implements GameClient {}

class _MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  group('MatchMakingPage', () {
    late GoRouterState goRouterState;

    setUp(() {
      goRouterState = _MockGoRouterState();
      when(() => goRouterState.queryParametersAll).thenReturn({
        'cardId': ['a', 'b', 'c'],
      });
    });

    test('routeBuilder returns a MatchMakingPage', () {
      expect(
        MatchMakingPage.routeBuilder(null, goRouterState),
        isA<MatchMakingPage>(),
      );
    });

    testWidgets('renders a MatchMakingView', (tester) async {
      await tester.pumpSubject();
      expect(find.byType(MatchMakingView), findsOneWidget);
    });
  });
}

extension MatchMakingPageTest on WidgetTester {
  Future<void> pumpSubject() {
    return pumpApp(
      MultiProvider(
        providers: [
          Provider<MatchMaker>(create: (_) => _MockMatchMaker()),
          Provider<GameClient>(create: (_) => _MockGameClient()),
        ],
        child: MatchMakingPage(
          playerCardIds: const ['a', 'b', 'c'],
        ),
      ),
    );
  }
}
