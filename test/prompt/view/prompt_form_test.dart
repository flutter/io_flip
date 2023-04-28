import 'dart:math' as math;

import 'package:bloc_test/bloc_test.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/prompt/prompt.dart';
import 'package:top_dash/settings/settings.dart';

import '../../helpers/helpers.dart';

class _MockPromptFormBloc extends MockBloc<PromptFormEvent, PromptFormState>
    implements PromptFormBloc {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockRandom extends Mock implements math.Random {}

void main() {
  late PromptFormBloc promptFormBloc;
  late math.Random randomGenerator;

  setUp(() {
    promptFormBloc = _MockPromptFormBloc();
    randomGenerator = _MockRandom();

    when(() => randomGenerator.nextInt(any())).thenReturn(0);
  });

  void mockState(PromptFormState state) {
    whenListen(
      promptFormBloc,
      Stream.value(state),
      initialState: state,
    );
  }

  const promptFormState = PromptFormState(
    status: PromptTermsStatus.loaded,
    prompts: Prompt(),
    characterClasses: ['Archer', 'Magician'],
    powers: ['Speed', 'Lazy'],
  );

  group('PromptForm', () {
    testWidgets('renders prompt form intro correctly', (tester) async {
      await tester.pumpSubject(promptFormBloc);

      expect(find.byType(FlowBuilder<Prompt>), findsOneWidget);
      expect(find.byType(PromptFormIntroView), findsOneWidget);
      expect(
        find.text(tester.l10n.letsGetStarted.toUpperCase()),
        findsOneWidget,
      );
    });

    testWidgets('renders character class form correctly', (tester) async {
      mockState(promptFormState);
      await tester.pumpSubject(promptFormBloc);
      await tester.tap(find.text(tester.l10n.letsGetStarted.toUpperCase()));
      await tester.pumpAndSettle();

      expect(
        find.text(tester.l10n.characterClassPromptPageTitle),
        findsOneWidget,
      );
      expect(find.byType(ListWheelScrollView), findsOneWidget);
      expect(
        find.text(tester.l10n.select.toUpperCase()),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders power form correctly and completes flow',
      (tester) async {
        mockState(promptFormState);
        await tester.pumpSubject(promptFormBloc);
        await tester.tap(find.text(tester.l10n.letsGetStarted.toUpperCase()));
        await tester.pumpAndSettle();

        await tester.tap(find.text(tester.l10n.select.toUpperCase()));
        await tester.pumpAndSettle();

        expect(find.text(tester.l10n.powerPromptPageTitle), findsOneWidget);
        expect(find.byType(ListWheelScrollView), findsOneWidget);

        await tester.tap(find.text(tester.l10n.select.toUpperCase()));
        await tester.pumpAndSettle();

        verify(
          () => promptFormBloc.add(
            const PromptSubmitted(
              data: Prompt(
                isIntroSeen: true,
                characterClass: 'Archer',
                power: 'Speed',
              ),
            ),
          ),
        ).called(1);
      },
    );
  });
}

extension PromptFormTest on WidgetTester {
  Future<void> pumpSubject(PromptFormBloc bloc, {math.Random? rng}) {
    final SettingsController settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    return pumpApp(
      Scaffold(
        body: BlocProvider.value(
          value: bloc,
          child: PromptForm(
            randomGenerator: rng,
          ),
        ),
      ),
      settingsController: settingsController,
    );
  }
}
