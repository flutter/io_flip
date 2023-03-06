import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/l10n/l10n.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HowToPlayPage', () {
    Widget buildSubject() => const Scaffold(body: HowToPlayPage());

    testWidgets('renders steps correctly', (tester) async {
      await tester.pumpApp(buildSubject());

      final l10n = tester.element(find.byType(HowToPlayPage)).l10n;

      final steps = <int, String>{
        1: l10n.howToPlayStepOneTitle,
        2: l10n.howToPlayStepTwoTitle,
        3: l10n.howToPlayStepThreeTitle,
        4: l10n.howToPlayStepFourTitle,
      };

      for (final step in steps.entries) {
        expect(find.text('${step.key}. ${step.value}'), findsOneWidget);
      }
    });
  });
}
