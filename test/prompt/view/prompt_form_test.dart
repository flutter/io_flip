import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/prompt/bloc/prompt_form_bloc.dart';
import 'package:top_dash/prompt/prompt.dart';

import '../../helpers/helpers.dart';

class _MockPromptFormBloc extends MockBloc<PromptFormEvent, PromptFormState>
    implements PromptFormBloc {}

void main() {
  late PromptFormBloc promptFormBloc;

  setUp(() {
    promptFormBloc = _MockPromptFormBloc();
  });

  group('PromptForm', () {
    testWidgets('renders character form correctly', (tester) async {
      await tester.pumpSubject(promptFormBloc);

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
      await tester.pumpSubject(promptFormBloc);

      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      expect(find.text(tester.l10n.powerPromptPageTitle), findsOneWidget);
      expect(find.text(tester.l10n.powerPromptPageSubtitle), findsOneWidget);
      expect(find.text(tester.l10n.powerPromptPageHint), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('renders environment form correctly and completes flow',
        (tester) async {
      await tester.pumpSubject(promptFormBloc);

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

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      verify(
        () => promptFormBloc.add(
          const PromptSubmitted(
            data: FlowData(
              character: '',
              power: '',
              environment: '',
            ),
          ),
        ),
      ).called(1);
    });
  });

  group('FowData', () {
    test('flow data correctly copies', () {
      const data1 = FlowData();
      final data2 = data1
          .copyWithNewAttribute('character')
          .copyWithNewAttribute('power')
          .copyWithNewAttribute('environment');

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

extension PromptFormTest on WidgetTester {
  Future<void> pumpSubject(PromptFormBloc bloc) {
    return pumpApp(
      Scaffold(
        body: BlocProvider.value(
          value: bloc,
          child: const PromptForm(),
        ),
      ),
    );
  }
}
