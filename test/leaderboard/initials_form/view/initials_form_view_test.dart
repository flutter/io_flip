import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash/share/share.dart';

import '../../../helpers/helpers.dart';

class _MockInitialsFormBloc
    extends MockBloc<InitialsFormEvent, InitialsFormState>
    implements InitialsFormBloc {}

void main() {
  late InitialsFormBloc initialsFormBloc;

  setUp(() {
    initialsFormBloc = _MockInitialsFormBloc();
  });

  group('InitialsFormView', () {
    testWidgets('renders enter button', (tester) async {
      when(() => initialsFormBloc.state).thenReturn(const InitialsFormState());
      await tester.pumpSubject(initialsFormBloc);

      final l10n = tester.element(find.byType(InitialsFormView)).l10n;

      expect(find.text(l10n.enter), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets(
      'renders error text when state status is InitialsFormStatus.failure',
      (tester) async {
        when(() => initialsFormBloc.state).thenReturn(
          const InitialsFormState(
            status: InitialsFormStatus.failure,
          ),
        );
        await tester.pumpSubject(initialsFormBloc);

        expect(find.text('Error submitting initials'), findsOneWidget);
      },
    );

    testWidgets(
      'routes navigation to home when initials submission is successful',
      (tester) async {
        final goRouter = MockGoRouter();

        whenListen(
          initialsFormBloc,
          Stream.fromIterable([
            const InitialsFormState(
              status: InitialsFormStatus.success,
            ),
          ]),
          initialState: const InitialsFormState(),
        );

        await tester.pumpSubject(
          initialsFormBloc,
          router: goRouter,
        );

        verify(() => goRouter.go('/')).called(1);
      },
    );

    testWidgets(
      'routes navigation to route passed in '
      'when initials submission is successful',
      (tester) async {
        final goRouter = MockGoRouter();

        whenListen(
          initialsFormBloc,
          Stream.fromIterable([
            const InitialsFormState(
              initials: 'AAA',
              status: InitialsFormStatus.success,
            ),
          ]),
          initialState: const InitialsFormState(),
        );
        const data =
            ShareHandPageData(initials: 'AAA', wins: 0, deckId: '', deck: []);

        await tester.pumpSubject(
          initialsFormBloc,
          router: goRouter,
          shareHandPageData: data,
        );
        verify(() => goRouter.goNamed('share_hand', extra: data)).called(1);
      },
    );

    group('initials textfield', () {
      testWidgets('renders correctly', (tester) async {
        when(() => initialsFormBloc.state)
            .thenReturn(const InitialsFormState());
        await tester.pumpSubject(initialsFormBloc);

        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('validates initials', (tester) async {
        when(() => initialsFormBloc.state).thenReturn(
          const InitialsFormState(
            initials: 'AAA',
            status: InitialsFormStatus.valid,
          ),
        );
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();

        expect(find.text(l10n.enterInitialsError), findsNothing);
      });

      testWidgets('shows error text on failed validation', (tester) async {
        when(() => initialsFormBloc.state).thenReturn(
          const InitialsFormState(
            initials: 'AA',
            status: InitialsFormStatus.invalid,
          ),
        );
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();

        expect(find.text(l10n.enterInitialsError), findsOneWidget);
      });

      testWidgets(
        'shows error text on failed validation due to blacklisted initials',
        (tester) async {
          when(() => initialsFormBloc.state).thenReturn(
            const InitialsFormState(
              initials: 'WTF',
              status: InitialsFormStatus.invalid,
            ),
          );
          await tester.pumpSubject(initialsFormBloc);

          final l10n = tester.element(find.byType(InitialsFormView)).l10n;

          await tester.tap(find.byType(FilledButton));
          await tester.pumpAndSettle();

          expect(find.text(l10n.enterInitialsError), findsOneWidget);
        },
      );

      testWidgets('capitalizes lowercase letters', (tester) async {
        when(() => initialsFormBloc.state)
            .thenReturn(const InitialsFormState());
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        await tester.enterText(find.byType(TextField), 'aaa');
        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();
        final input = tester.widget<EditableText>(find.byType(EditableText));
        expect(input.controller.text == 'AAA', isTrue);

        expect(find.text(l10n.enterInitialsError), findsNothing);
      });
    });
  });
}

extension InitialsFormViewTest on WidgetTester {
  Future<void> pumpSubject(
    InitialsFormBloc bloc, {
    GoRouter? router,
    ShareHandPageData? shareHandPageData,
  }) async {
    return pumpApp(
      BlocProvider.value(
        value: bloc,
        child: Scaffold(
          body: InitialsFormView(
            shareHandPageData: shareHandPageData,
          ),
        ),
      ),
      router: router,
    );
  }
}
