import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/audio/widgets/widgets.dart';
import 'package:top_dash/info/info.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/share/views/views.dart';
import 'package:top_dash/share/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockSettingsController extends Mock implements SettingsController {}

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
  late GoRouterState goRouterState;
  setUp(() {
    goRouterState = _MockGoRouterState();
    when(() => goRouterState.extra).thenReturn(pageData);
    when(() => goRouterState.queryParams).thenReturn({});
  });
  group('ShareHandPage', () {
    test('routeBuilder returns a ShareHandPage', () {
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
      await tester.pumpSubject();
      expect(find.byType(ShareHandPage), findsOneWidget);
    });

    testWidgets('renders a IoFlipLogo widget', (tester) async {
      await tester.pumpSubject();
      expect(find.byType(IoFlipLogo), findsOneWidget);
    });

    testWidgets('renders a CardFan widget', (tester) async {
      await tester.pumpSubject();
      expect(find.byType(CardFan), findsOneWidget);
    });

    testWidgets('renders the users wins and initials', (tester) async {
      await tester.pumpSubject();
      expect(find.text('5 ${tester.l10n.winStreakLabel}'), findsOneWidget);
      expect(find.text('AAA'), findsOneWidget);
    });

    testWidgets('renders the title', (tester) async {
      await tester.pumpSubject();
      expect(find.text(tester.l10n.shareTeamTitle), findsOneWidget);
    });

    testWidgets('renders a menu button', (tester) async {
      await tester.pumpSubject();
      expect(find.text(tester.l10n.mainMenuButtonLabel), findsOneWidget);
    });

    testWidgets('renders a routes to main menu on button tapped',
        (tester) async {
      final goRouter = _MockGoRouter();
      when(() => goRouter.go('/')).thenAnswer((_) {});
      await tester.pumpSubject(
        router: goRouter,
      );

      await tester.tap(find.text(tester.l10n.mainMenuButtonLabel));
      verify(() => goRouter.go('/')).called(1);
    });

    testWidgets('renders a share button', (tester) async {
      await tester.pumpSubject();
      expect(find.text(tester.l10n.shareButtonLabel), findsOneWidget);
    });

    testWidgets('renders a dialog on share button tapped', (tester) async {
      final shareResource = _MockShareResource();
      when(() => shareResource.facebookShareHandUrl(any())).thenReturn('');
      when(() => shareResource.twitterShareHandUrl(any())).thenReturn('');

      await tester.pumpSubject(
        shareResource: shareResource,
      );
      await tester.tap(find.text(tester.l10n.shareButtonLabel));
      await tester.pumpAndSettle();
      expect(find.byType(ShareHandDialog), findsOneWidget);
    });

    testWidgets('renders a music button', (tester) async {
      await tester.pumpSubject();
      expect(find.byType(AudioToggleButton), findsOneWidget);
    });

    testWidgets('renders a dialog on info button tapped', (tester) async {
      final shareResource = _MockShareResource();
      when(() => shareResource.facebookShareHandUrl(any())).thenReturn('');
      when(() => shareResource.twitterShareHandUrl(any())).thenReturn('');

      await tester.pumpSubject(
        shareResource: shareResource,
      );
      await tester.tap(find.byKey(const Key('share_page_info_button')));
      await tester.pumpAndSettle();

      expect(find.byType(InfoView), findsOneWidget);
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject({
    ShareResource? shareResource,
    GoRouter? router,
  }) async {
    final SettingsController settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    await mockNetworkImages(() {
      return pumpApp(
        const ShareHandPage(
          wins: 5,
          initials: 'AAA',
          deckId: '',
          deck: [card, card, card],
        ),
        shareResource: shareResource,
        router: router,
        settingsController: settingsController,
      );
    });
  }
}
