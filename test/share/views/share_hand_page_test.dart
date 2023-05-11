import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/widgets/widgets.dart';
import 'package:io_flip/info/info.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:io_flip/share/views/views.dart';
import 'package:io_flip/share/widgets/widgets.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockGoRouter extends Mock implements GoRouter {}

class _MockShareResource extends Mock implements ShareResource {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

const card = Card(
  id: '',
  name: 'name',
  description: 'description',
  image: '',
  rarity: false,
  power: 1,
  suit: Suit.air,
);
const pageData = ShareHandPageData(
  initials: 'AAA',
  wins: 0,
  deck: Deck(id: '', userId: '', cards: []),
);

void main() {
  late GoRouterState goRouterState;
  late UrlLauncherPlatform urlLauncher;

  setUp(() {
    goRouterState = _MockGoRouterState();
    when(() => goRouterState.extra).thenReturn(pageData);
    when(() => goRouterState.queryParams).thenReturn({});

    urlLauncher = _MockUrlLauncher();
    when(
      () => urlLauncher.canLaunch(any()),
    ).thenAnswer((_) async => true);

    when(
      () => urlLauncher.launchUrl(any(), any()),
    ).thenAnswer((_) async => true);
    UrlLauncherPlatform.instance = urlLauncher;
  });

  setUpAll(() {
    registerFallbackValue(_FakeLaunchOptions());
  });

  group('ShareHandPage', () {
    test('routeBuilder returns a ShareHandPage', () {
      expect(
        ShareHandPage.routeBuilder(null, goRouterState),
        isA<ShareHandPage>()
            .having((page) => page.deck, 'deck', pageData.deck)
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

    testWidgets('tapping io link opens io', (tester) async {
      await tester.pumpSubject();
      await tester.tap(find.text(tester.l10n.ioLinkLabel));

      verify(
        () => urlLauncher.launchUrl(ExternalLinks.googleIO, any()),
      ).called(1);
    });

    testWidgets('tapping how its made link opens how its made', (tester) async {
      await tester.pumpSubject();
      await tester.tap(find.text(tester.l10n.howItsMadeLinkLabel));

      verify(
        () => urlLauncher.launchUrl(ExternalLinks.howItsMade, any()),
      ).called(1);
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject({
    ShareResource? shareResource,
    GoRouter? router,
  }) async {
    final SettingsController settingsController = _MockSettingsController();
    await mockNetworkImages(() {
      return pumpApp(
        const ShareHandPage(
          wins: 5,
          initials: 'AAA',
          deck: Deck(id: '', userId: '', cards: [card, card, card]),
        ),
        shareResource: shareResource,
        router: router,
        settingsController: settingsController,
      );
    });
  }
}
