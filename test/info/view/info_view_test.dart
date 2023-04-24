import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/info/info.dart';

import '../../helpers/helpers.dart';

void main() {
  group('InfoView', () {
    Widget buildSubject() => const Scaffold(body: InfoView());

    testWidgets('renders correct texts', (tester) async {
      await tester.pumpApp(buildSubject());

      final l10n = tester.l10n;

      final descriptionText = '${l10n.infoDialogDescriptionPrefix} '
          '${l10n.infoDialogDescriptionInfixOne} '
          '${l10n.infoDialogDescriptionInfixTwo} '
          '${l10n.infoDialogDescriptionSuffix}';

      final expectedTexts = [
        l10n.infoDialogTitle,
        descriptionText,
        l10n.infoDialogOtherLinks,
        l10n.ioLinkLabel,
        l10n.privacyPolicyLinkLabel,
        l10n.termsOfServiceLinkLabel,
        l10n.faqLinkLabel,
      ];

      for (final text in expectedTexts) {
        expect(find.text(text, findRichText: true), findsOneWidget);
      }
    });

    testWidgets('tapping close button pops go router', (tester) async {
      final goRouter = MockGoRouter();
      when(goRouter.canPop).thenReturn(true);

      await tester.pumpApp(
        buildSubject(),
        router: goRouter,
      );

      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();

      verify(goRouter.pop).called(1);
    });
  });
}
