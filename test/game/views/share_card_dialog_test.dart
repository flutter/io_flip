import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/game/views/share_card_dialog.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

String? launchedUrl;
const shareUrl = 'https://example.com';
const card = Card(
  id: '',
  name: 'name',
  description: 'description',
  image: '',
  rarity: false,
  power: 1,
  suit: Suit.air,
);

void main() {
  group('ShareCardDialog', () {
    setUp(() {
      launchedUrl = null;
    });

    testWidgets('renders a Dialog', (tester) async {
      await tester.pumpSubject();

      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('renders a GameCard', (tester) async {
      await tester.pumpSubject();

      expect(find.byType(GameCard), findsOneWidget);
    });

    testWidgets('renders a Twitter button', (tester) async {
      await tester.pumpSubject();

      expect(find.text(tester.l10n.twitterButtonLabel), findsOneWidget);
    });

    testWidgets(
      'tapping the Twitter button launches the correct url',
      (tester) async {
        await tester.pumpSubject();

        await tester.tap(find.text(tester.l10n.twitterButtonLabel));

        expect(
          launchedUrl,
          equals(shareUrl),
        );
      },
    );

    testWidgets('renders a Facebook button', (tester) async {
      await tester.pumpSubject();

      expect(find.text(tester.l10n.facebookButtonLabel), findsOneWidget);
    });

    testWidgets(
      'tapping the Facebook button launches the correct url',
      (tester) async {
        // The default display size is too small to include the Facebook button.
        tester.setDisplaySize(const Size(1200, 800));
        await tester.pumpSubject();

        await tester.tap(find.text(tester.l10n.facebookButtonLabel));

        expect(launchedUrl, equals(shareUrl));
      },
    );

    testWidgets('renders landscape mode', (tester) async {
      tester.setLandscapeDisplaySize();
      await tester.pumpSubject();
      expect(
        find.byKey(const Key('large_dialog')),
        findsOneWidget,
      );
    });

    testWidgets('renders portrait mode', (tester) async {
      tester.setPortraitDisplaySize();
      await tester.pumpSubject();
      expect(
        find.byKey(const Key('small_dialog')),
        findsOneWidget,
      );
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject() async {
    await mockNetworkImages(() {
      return pumpApp(
        ShareCardDialog(
          twitterShareUrl: shareUrl,
          facebookShareUrl: shareUrl,
          urlLauncher: (url) async {
            launchedUrl = url;
          },
          card: card,
        ),
      );
    });
  }
}
