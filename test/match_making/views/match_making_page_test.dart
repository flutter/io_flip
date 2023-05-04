// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockSettingsController extends Mock implements SettingsController {}

const deck = [
  Card(
    id: 'a',
    name: '',
    description: '',
    image: '',
    power: 1,
    rarity: false,
    suit: Suit.air,
  ),
  Card(
    id: 'b',
    name: '',
    description: '',
    image: '',
    power: 1,
    rarity: false,
    suit: Suit.air,
  ),
  Card(
    id: 'c',
    name: '',
    description: '',
    image: '',
    power: 1,
    rarity: false,
    suit: Suit.air,
  ),
];
final pageData = MatchMakingPageData(cards: deck);
void main() {
  group('MatchMakingPage', () {
    late GoRouterState goRouterState;

    setUp(() {
      goRouterState = _MockGoRouterState();
      when(() => goRouterState.extra).thenReturn(pageData);
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
            deck: deck,
            createPrivateMatch: false,
            inviteCode: 'inviteCode',
          ).mapEvent(),
          equals(GuestPrivateMatchRequested('inviteCode')),
        );
      });

      test('correctly maps to PrivateMatchRequested', () {
        expect(
          MatchMakingPage(
            deck: deck,
            createPrivateMatch: true,
            inviteCode: null,
          ).mapEvent(),
          equals(PrivateMatchRequested()),
        );
      });
      test('correctly maps to MatchRequested', () {
        expect(
          MatchMakingPage(
            deck: deck,
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

extension GameSummaryViewTest on WidgetTester {
  Future<void> pumpSubject({
    GoRouter? goRouter,
  }) {
    final SettingsController settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    return mockNetworkImages(() {
      return pumpApp(
        MatchMakingPage(
          deck: deck,
          createPrivateMatch: false,
          inviteCode: null,
        ),
        router: goRouter,
        settingsController: settingsController,
      );
    });
  }
}
