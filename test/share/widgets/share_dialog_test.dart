import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/share/widgets/widgets.dart';

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
  group('ShareDialog', () {
    setUpAll(() {
      launchedUrl = null;
    });

    testWidgets('renders the content', (tester) async {
      await tester.pumpSubject(content: const Text('test'));

      expect(find.text('test'), findsOneWidget);
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
          shareUrl,
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
        await tester.pumpSubject();

        await tester.tap(find.text(tester.l10n.facebookButtonLabel));

        expect(
          launchedUrl,
          equals(
            shareUrl,
          ),
        );
      },
    );

    testWidgets('renders a save button', (tester) async {
      await tester.pumpSubject();
      expect(find.text(tester.l10n.saveButtonLabel), findsOneWidget);
    });

    testWidgets('renders a downloading button while the downloading',
        (tester) async {
      await tester.pumpSubject(loading: true);
      expect(find.text(tester.l10n.downloadingButtonLabel), findsOneWidget);
    });

    testWidgets('renders a success message while on download complete',
        (tester) async {
      await tester.pumpSubject(success: true);
      expect(find.text(tester.l10n.downloadCompleteLabel), findsOneWidget);
    });

    testWidgets('renders a fail message while on download failure',
        (tester) async {
      await tester.pumpSubject(success: false);
      expect(find.text(tester.l10n.downloadFailedLabel), findsOneWidget);
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject({
    Widget? content,
    bool? loading,
    bool? success,
  }) async {
    await mockNetworkImages(() {
      return pumpApp(
        ShareDialog(
          loading: loading ?? false,
          success: success ?? false,
          content: content ?? Container(),
          twitterShareUrl: shareUrl,
          facebookShareUrl: shareUrl,
          urlLauncher: (url) async {
            launchedUrl = url;
          },
        ),
      );
    });
  }
}
