import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/share/share.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareDialog', () {
    const shareUrl = 'https://example.com';
    const shareText = 'Check out this hand!';

    String? launchedUrl;

    setUp(() {
      launchedUrl = null;
    });

    Widget buildSubject() => ShareDialog(
          shareUrl: shareUrl,
          shareText: shareText,
          urlLauncher: (url) async {
            launchedUrl = url;
          },
        );

    testWidgets('renders a Dialog', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('renders a Twitter button', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Twitter'), findsOneWidget);
    });

    testWidgets(
      'tapping the Twitter button launches the correct url',
      (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Twitter'));

        expect(
          launchedUrl,
          'https://twitter.com/intent/tweet?url=$shareUrl&text=$shareText',
        );
      },
    );

    testWidgets('renders a Facebook button', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Facebook'), findsOneWidget);
    });

    testWidgets(
      'tapping the Facebook button launches the correct url',
      (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Facebook'));

        expect(
          launchedUrl,
          'https://www.facebook.com/sharer.php?u=$shareUrl&quote=$shareText',
        );
      },
    );
  });
}
