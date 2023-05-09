import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/leaderboard/initials_form/initials_form.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';

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
      expect(find.byType(RoundedButton), findsOneWidget);
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
              initials: ['A', 'A', 'A'],
              status: InitialsFormStatus.success,
            ),
          ]),
          initialState: const InitialsFormState(),
        );
        const data = ShareHandPageData(
          initials: 'AAA',
          wins: 0,
          deck: Deck(id: '', userId: '', cards: []),
        );

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

        expect(find.byType(TextFormField), findsNWidgets(3));
      });

      testWidgets('correctly updates fields and focus', (tester) async {
        when(() => initialsFormBloc.state)
            .thenReturn(const InitialsFormState());
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        final initial0 = find.byKey(const Key('initial_form_field_0'));
        final initial1 = find.byKey(const Key('initial_form_field_1'));
        final initial2 = find.byKey(const Key('initial_form_field_2'));

        await tester.enterText(initial0, 'a');
        await tester.enterText(initial1, 'a');
        await tester.enterText(initial2, 'a');

        await tester.pumpAndSettle();

        final inputs =
            tester.widgetList<EditableText>(find.byType(EditableText));
        for (final input in inputs) {
          expect(input.controller.text == 'A', isTrue);
        }

        await tester.enterText(initial2, '');
        await tester.pumpAndSettle();

        expect(inputs.last.controller.text, equals(emptyCharacter));
        expect(find.text(l10n.enterInitialsError), findsNothing);
      });

      testWidgets('correctly moves focus on backspaces', (tester) async {
        when(() => initialsFormBloc.state)
            .thenReturn(const InitialsFormState());
        await tester.pumpSubject(initialsFormBloc);

        final initial0 = find.byKey(const Key('initial_form_field_0'));
        final initial2 = find.byKey(const Key('initial_form_field_2'));

        await tester.enterText(initial0, 'a');
        await tester.enterText(initial2, 'a');

        await tester.pumpAndSettle();
        await tester.tap(initial2);

        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();

        final inputs =
            tester.widgetList<EditableText>(find.byType(EditableText));

        for (final input in inputs) {
          expect(input.controller.text == emptyCharacter, isTrue);
        }
      });

      testWidgets('moves focus on typing repeated letters', (tester) async {
        when(() => initialsFormBloc.state)
            .thenReturn(const InitialsFormState());
        await tester.pumpSubject(initialsFormBloc);

        final initial0 = find.byKey(const Key('initial_form_field_0'));
        final initial1 = find.byKey(const Key('initial_form_field_1'));
        final initial2 = find.byKey(const Key('initial_form_field_2'));

        await tester.enterText(initial0, 'a');
        await tester.enterText(initial1, 'a');
        await tester.enterText(initial2, 'a');

        await tester.pumpAndSettle();
        await tester.tap(initial0);

        await tester.pumpAndSettle();

        await tester.enterText(initial0, 'aa');
        await tester.enterText(initial1, 'ab');
        await tester.enterText(initial0, 'aa');

        final inputs =
            tester.widgetList<EditableText>(find.byType(EditableText));
        await tester.pumpAndSettle();

        expect(inputs.elementAt(1).controller.text, 'B');
      });

      testWidgets('validates initials', (tester) async {
        when(() => initialsFormBloc.state).thenReturn(
          const InitialsFormState(
            initials: ['A', 'A', 'A'],
            status: InitialsFormStatus.valid,
          ),
        );
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        await tester.tap(find.byType(RoundedButton));
        await tester.pumpAndSettle();

        expect(find.text(l10n.enterInitialsError), findsNothing);
      });

      testWidgets('shows error text on failed validation', (tester) async {
        when(() => initialsFormBloc.state).thenReturn(
          const InitialsFormState(
            initials: ['A', 'A', ''],
            status: InitialsFormStatus.invalid,
          ),
        );
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        expect(find.text(l10n.enterInitialsError), findsOneWidget);
      });

      testWidgets(
        'requests focus on last input when status is '
        'InitialsFormStatus.blacklisted',
        (tester) async {
          whenListen(
            initialsFormBloc,
            Stream.fromIterable([
              const InitialsFormState(
                initials: ['A', 'A', 'A'],
                status: InitialsFormStatus.blacklisted,
              ),
            ]),
            initialState: const InitialsFormState(),
          );

          await tester.pumpSubject(initialsFormBloc);

          final inputs =
              tester.widgetList<EditableText>(find.byType(EditableText));

          for (final input in inputs) {
            if (input != inputs.last) {
              expect(input.focusNode.hasFocus, isFalse);
            } else {
              expect(input.focusNode.hasFocus, isTrue);
            }
          }
        },
      );

      testWidgets('shows blacklist error text on blacklist initials',
          (tester) async {
        when(() => initialsFormBloc.state).thenReturn(
          const InitialsFormState(
            initials: ['A', 'A', 'A'],
            status: InitialsFormStatus.blacklisted,
          ),
        );
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        expect(find.text(l10n.blacklistedErrorMessage), findsOneWidget);
      });

      testWidgets('shows blacklist error styling on blacklist initials',
          (tester) async {
        when(() => initialsFormBloc.state).thenReturn(
          const InitialsFormState(
            initials: ['A', 'A', 'A'],
            status: InitialsFormStatus.blacklisted,
          ),
        );
        await tester.pumpSubject(initialsFormBloc);
        final blacklistDecoration = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              ((widget.decoration! as BoxDecoration).border ==
                  Border.all(color: IoFlipColors.seedRed, width: 2)),
        );

        expect(blacklistDecoration, findsNWidgets(3));
      });

      testWidgets('capitalizes lowercase letters', (tester) async {
        when(() => initialsFormBloc.state)
            .thenReturn(const InitialsFormState());
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        final initial0 = find.byKey(const Key('initial_form_field_0'));
        final initial1 = find.byKey(const Key('initial_form_field_1'));
        final initial2 = find.byKey(const Key('initial_form_field_2'));

        await tester.enterText(initial0, 'a');
        await tester.enterText(initial1, 'a');
        await tester.enterText(initial2, 'a');

        await tester.pumpAndSettle();

        final inputs =
            tester.widgetList<EditableText>(find.byType(EditableText));
        for (final input in inputs) {
          expect(input.controller.text == 'A', isTrue);
        }

        expect(find.text(l10n.enterInitialsError), findsNothing);
      });

      testWidgets('typing two letters in the same field keeps last letter',
          (tester) async {
        when(() => initialsFormBloc.state)
            .thenReturn(const InitialsFormState());
        await tester.pumpSubject(initialsFormBloc);

        final l10n = tester.element(find.byType(InitialsFormView)).l10n;

        final initial = find.byKey(const Key('initial_form_field_0'));

        await tester.enterText(initial, 'ab');

        await tester.pumpAndSettle();

        final input =
            tester.widget<EditableText>(find.byType(EditableText).first);
        expect(input.controller.text == 'B', isTrue);

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
