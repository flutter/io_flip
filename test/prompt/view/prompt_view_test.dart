// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockPromptFormBloc extends MockBloc<PromptFormEvent, PromptFormState>
    implements PromptFormBloc {}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  late PromptFormBloc promptFormBloc;
  const prompt = Prompt(
    isIntroSeen: true,
    characterClass: 'class',
    power: 'power',
  );

  const characterClasses = ['Archer', 'Magician'];
  const powers = ['Speed', 'Lazy'];

  setUp(() {
    promptFormBloc = _MockPromptFormBloc();
  });

  group('PromptView', () {
    testWidgets('renders prompt view', (tester) async {
      when(() => promptFormBloc.state).thenReturn(PromptFormState.initial());
      await tester.pumpSubject(promptFormBloc, null);

      expect(find.byType(PromptView), findsOneWidget);
    });

    testWidgets('renders error message view', (tester) async {
      when(() => promptFormBloc.state).thenReturn(
        PromptFormState(status: PromptTermsStatus.failed, prompts: Prompt()),
      );
      await tester.pumpSubject(promptFormBloc, null);

      expect(find.byType(PromptView), findsOneWidget);
    });
  });

  group('navigation', () {
    setUp(() {
      whenListen(
        promptFormBloc,
        Stream<PromptFormState>.fromIterable([
          PromptFormState.initial(),
          PromptFormState(
            status: PromptTermsStatus.loaded,
            characterClasses: characterClasses,
            powers: powers,
            prompts: prompt,
          ),
        ]),
        initialState: const PromptFormState.initial(),
      );
    });

    testWidgets('can navigate to draft page', (tester) async {
      final goRouter = MockGoRouter();
      await tester.pumpSubject(promptFormBloc, goRouter);
      await tester.pumpAndSettle();

      verify(
        () => goRouter.go('/draft', extra: prompt),
      ).called(1);
    });
  });
}

extension PromptViewTest on WidgetTester {
  Future<void> pumpSubject(PromptFormBloc bloc, GoRouter? goRouter) {
    final SettingsController settingsController = _MockSettingsController();

    return pumpApp(
      Scaffold(
        body: BlocProvider.value(
          value: bloc,
          child: const PromptView(),
        ),
      ),
      router: goRouter,
      settingsController: settingsController,
    );
  }
}
