import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/prompt/prompt.dart';

import '../../helpers/helpers.dart';

class _MockPromptFormBloc extends MockBloc<PromptFormEvent, PromptFormState>
    implements PromptFormBloc {}

class _MockPromptResource extends Mock implements PromptResource {}

void main() {
  late PromptFormBloc promptFormBloc;
  const prompt = Prompt(
    character: 'za',
    power: 'zz',
    environment: 'zz',
  );

  setUp(() {
    promptFormBloc = _MockPromptFormBloc();
  });

  group('PromptView', () {
    setUp(() {
      when(() => promptFormBloc.state).thenReturn(
        const PromptFormState(),
      );
    });

    testWidgets('renders prompt view', (tester) async {
      await tester.pumpSubject(promptFormBloc, null);

      expect(find.byType(PromptView), findsOneWidget);
    });
  });

  group('navigation', () {
    setUp(() {
      whenListen(
        promptFormBloc,
        Stream<PromptFormState>.value(
          const PromptFormState(
            prompts: prompt,
          ),
        ),
        initialState: const PromptFormState(),
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

    testWidgets('navigates to draft page', (tester) async {
      final promptResource = _MockPromptResource();
      when(promptResource.getPromptWhitelist).thenAnswer((_) async => ['test']);
      final bloc = PromptFormBloc(promptResource: promptResource);
      await tester.pumpSubject(bloc, null);

      bloc.add(const PromptSubmitted(data: prompt));
      await tester.pumpAndSettle();

      expect(find.byType(DraftPage), findsOneWidget);
    });
  });
}

extension PromptViewTest on WidgetTester {
  Future<void> pumpSubject(PromptFormBloc bloc, GoRouter? goRouter) {
    return pumpApp(
      Scaffold(
        body: BlocProvider.value(
          value: bloc,
          child: const PromptView(),
        ),
      ),
      router: goRouter,
    );
  }
}
