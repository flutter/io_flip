import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

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
    testWidgets('renders continue button', (tester) async {
      when(() => initialsFormBloc.state).thenReturn(const InitialsFormState());
      await tester.pumpSubject(initialsFormBloc);

      final l10n = tester.element(find.byType(InitialsFormView)).l10n;

      expect(find.text(l10n.continueButton.toUpperCase()), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

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

        await tester.tap(find.byType(OutlinedButton));
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

        await tester.tap(find.byType(OutlinedButton));
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

          await tester.tap(find.byType(OutlinedButton));
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
        await tester.tap(find.byType(OutlinedButton));
        await tester.pumpAndSettle();
        final input = tester.widget<EditableText>(find.byType(EditableText));
        expect(input.controller.text == 'AAA', isTrue);

        expect(find.text(l10n.enterInitialsError), findsNothing);
      });
    });
  });
}

extension InitialsFormViewTest on WidgetTester {
  Future<void> pumpSubject(InitialsFormBloc bloc) async {
    return pumpApp(
      BlocProvider.value(
        value: bloc,
        child: const Scaffold(body: InitialsFormView()),
      ),
    );
  }
}
