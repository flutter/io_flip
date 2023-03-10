// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/match_making/match_making.dart';

import '../../helpers/helpers.dart';

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

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
      when(() => goRouterState.queryParams).thenReturn({});
    });

    test('routeBuilder returns a MatchMakingPage', () {
      expect(
        MatchMakingPage.routeBuilder(null, goRouterState),
        isA<MatchMakingPage>(),
      );
    });

    group('mapEvent', () {
      test('correctly maps to GuestPrivateMatchRequested', () {
        expect(
          MatchMakingPage(
            playerCardIds: const ['a', 'b', 'c'],
            createPrivateMatch: false,
            inviteCode: 'inviteCode',
          ).mapEvent(),
          equals(GuestPrivateMatchRequested('inviteCode')),
        );
      });
      test('correctly maps to PrivateMatchRequested', () {
        expect(
          MatchMakingPage(
            playerCardIds: const ['a', 'b', 'c'],
            createPrivateMatch: true,
            inviteCode: null,
          ).mapEvent(),
          equals(PrivateMatchRequested()),
        );
      });
      test('correctly maps to MatchRequested', () {
        expect(
          MatchMakingPage(
            playerCardIds: const ['a', 'b', 'c'],
            createPrivateMatch: false,
            inviteCode: null,
          ).mapEvent(),
          equals(MatchRequested()),
        );
      });
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
          Provider<MatchMakerRepository>(
            create: (_) => _MockMatchMakerRepository(),
          ),
          Provider<GameClient>(create: (_) => _MockGameClient()),
        ],
        child: MatchMakingPage(
          playerCardIds: const ['a', 'b', 'c'],
          createPrivateMatch: false,
          inviteCode: null,
        ),
      ),
    );
  }
}
