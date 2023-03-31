import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/prompt/prompt.dart';

import '../helpers/helpers.dart';

void main() {
  group('PromptPage', () {
    testWidgets('renders character form correctly', (tester) async {
      await tester.pumpSubject();

      expect(find.byType(FlowBuilder<FlowData>), findsOneWidget);
      expect(find.text(tester.l10n.characterPromptPageTitle), findsOneWidget);
      expect(
        find.text(tester.l10n.characterPromptPageSubtitle),
        findsOneWidget,
      );
      expect(find.text(tester.l10n.characterPromptPageHint), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('renders power form correctly', (tester) async {
      await tester.pumpSubject();

      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.text(tester.l10n.powerPromptPageTitle), findsOneWidget);
      expect(find.text(tester.l10n.powerPromptPageSubtitle), findsOneWidget);
      expect(find.text(tester.l10n.powerPromptPageHint), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('renders environment form correctly', (tester) async {
      await tester.pumpSubject();

      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.text(tester.l10n.environmentPromptPageTitle), findsOneWidget);
      expect(
        find.text(tester.l10n.environmentPromptPageSubtitle),
        findsOneWidget,
      );

      expect(find.text(tester.l10n.environmentPromptHint), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    test('flow data correctly copies', () {
      const data1 = FlowData();
      final data2 = data1
        ..copyWithNewAttribute('character')
        ..copyWithNewAttribute('power')
        ..copyWithNewAttribute('environment');

      expect(
        data2,
        equals(
          const FlowData(
            character: 'character',
            power: 'power',
            environment: 'environment',
          ),
        ),
      );
    });
  });
}

extension PromptPageTest on WidgetTester {
  Future<void> pumpSubject() {
    return pumpApp(const Scaffold(body: PromptPage()));
  }
}
