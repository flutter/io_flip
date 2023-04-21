import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/share/views/views.dart';
import 'package:top_dash/share/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockGoRouter extends Mock implements GoRouter {}

class _MockShareResource extends Mock implements ShareResource {}

const card = Card(
  id: '',
  name: 'name',
  description: 'description',
  image: '',
  rarity: false,
  power: 1,
  suit: Suit.air,
);
const pageData =
    ShareHandPageData(initials: 'AAA', wins: 0, deckId: '', deck: []);

void main() {
  late SettingsController settingsController;
  late GoRouterState goRouterState;
  setUp(() {
    settingsController = _MockSettingsController();
    goRouterState = _MockGoRouterState();
    when(() => goRouterState.extra).thenReturn(pageData);
    when(() => goRouterState.queryParams).thenReturn({});
    when(() => settingsController.musicOn).thenReturn(ValueNotifier(true));
    when(() => settingsController.toggleMusicOn()).thenAnswer((_) {});
  });
  group('ShareHandPage', () {
    test('routeBuilder returns a MatchMakingPage', () {
      expect(
        ShareHandPage.routeBuilder(null, goRouterState),
        isA<ShareHandPage>()
            .having((page) => page.deck, 'deck', pageData.deck)
            .having((page) => page.deckId, 'deckId', pageData.deckId)
            .having((page) => page.wins, 'wins', pageData.wins)
            .having((page) => page.initials, 'initials', pageData.initials),
      );
    });
    testWidgets('renders', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byType(ShareHandPage), findsOneWidget);
    });

    testWidgets('renders a IoFlipLogo widget', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byType(IoFlipLogo), findsOneWidget);
    });

    testWidgets('renders a CardFan widget', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byType(CardFan), findsOneWidget);
    });

    testWidgets('renders the users wins and initials', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.text('5 ${tester.l10n.winStreakLabel}'), findsOneWidget);
      expect(find.text('AAA'), findsOneWidget);
    });

    testWidgets('renders the title', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.text(tester.l10n.shareTeamTitle), findsOneWidget);
    });

    testWidgets('renders a menu button', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.text(tester.l10n.mainMenuButtonLabel), findsOneWidget);
    });

    testWidgets('renders a routes to main menu on button tapped',
        (tester) async {
      final goRouter = _MockGoRouter();
      when(() => goRouter.go('/')).thenAnswer((_) {});
      await tester.pumpSubject(
        settingsController,
        router: goRouter,
      );

      await tester.tap(find.text(tester.l10n.mainMenuButtonLabel));
      verify(() => goRouter.go('/')).called(1);
    });

    testWidgets('renders a share button', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.text(tester.l10n.shareButtonLabel), findsOneWidget);
    });

    testWidgets('renders a dialog on share button tapped', (tester) async {
      final shareResource = _MockShareResource();
      when(() => shareResource.facebookShareHandUrl(any())).thenReturn('');
      when(() => shareResource.twitterShareHandUrl(any())).thenReturn('');

      await tester.pumpSubject(
        settingsController,
        shareResource: shareResource,
      );
      await tester.tap(find.text(tester.l10n.shareButtonLabel));
      await tester.pumpAndSettle();
      expect(find.byType(ShareHandDialog), findsOneWidget);
    });

    testWidgets('renders a music button', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('renders a music button', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('renders a music off button when music is off', (tester) async {
      when(() => settingsController.musicOn).thenReturn(ValueNotifier(false));
      await tester.pumpSubject(settingsController);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });

    testWidgets(
      'tapping the music button toggles the music',
      (tester) async {
        await tester.pumpSubject(settingsController);
        await tester.tap(find.byIcon(Icons.volume_up));

        verify(() => settingsController.toggleMusicOn()).called(1);
      },
    );
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject(
    SettingsController settingsController, {
    ShareResource? shareResource,
    GoRouter? router,
  }) async {
    await mockNetworkImages(() {
      return pumpApp(
        const ShareHandPage(
          wins: 5,
          initials: 'AAA',
          deckId: '',
          deck: [card, card, card],
        ),
        settingsController: settingsController,
        shareResource: shareResource,
        router: router,
      );
    });
  }
}
