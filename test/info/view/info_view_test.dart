import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/info/info.dart';

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
        l10n.privacyPolicyLinkLabel,
        l10n.termsOfServiceLinkLabel,
        l10n.faqLinkLabel,
        l10n.devButtonLabel,
      ];

      for (final text in expectedTexts) {
        expect(find.text(text, findRichText: true), findsOneWidget);
      }
    });
  });
}
