import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/terms_of_use/terms_of_use.dart';

import '../../helpers/helpers.dart';

class _MockTermsOfUseCubit extends MockCubit<bool> implements TermsOfUseCubit {}

void main() {
  late TermsOfUseCubit cubit;

  setUp(() {
    cubit = _MockTermsOfUseCubit();
    when(cubit.acceptTermsOfUse).thenAnswer((_) => true);
  });

  group('TermsOfUseView', () {
    Widget buildSubject() => const Scaffold(body: TermsOfUseView());

    testWidgets('renders correct texts', (tester) async {
      await tester.pumpApp(buildSubject());

      final l10n = tester.l10n;

      final descriptionText = '${l10n.termsOfUseDescriptionPrefix} '
          '${l10n.termsOfUseDescriptionInfixOne} '
          '${l10n.termsOfUseDescriptionInfixTwo} '
          '${l10n.termsOfUseDescriptionSuffix}';

      final expectedTexts = [
        l10n.termsOfUseTitle,
        descriptionText,
        l10n.termsOfUseAcceptLabel,
        l10n.termsOfUseDeclineLabel,
      ];

      for (final text in expectedTexts) {
        expect(find.text(text, findRichText: true), findsOneWidget);
      }
    });

    testWidgets('tapping decline button pops go router', (tester) async {
      final goRouter = MockGoRouter();
      when(goRouter.canPop).thenReturn(true);

      await tester.pumpApp(
        buildSubject(),
        router: goRouter,
      );

      final l10n = tester.l10n;

      await tester.tap(find.text(l10n.termsOfUseDeclineLabel));
      await tester.pumpAndSettle();

      verify(goRouter.pop).called(1);
    });

    testWidgets(
      'tapping accept button calls acceptTermsOfUse and pops go router',
      (tester) async {
        final goRouter = MockGoRouter();
        when(goRouter.canPop).thenReturn(true);

        await tester.pumpApp(
          BlocProvider.value(
            value: cubit,
            child: buildSubject(),
          ),
          router: goRouter,
        );

        final l10n = tester.l10n;

        await tester.tap(find.text(l10n.termsOfUseAcceptLabel));
        await tester.pumpAndSettle();

        verify(cubit.acceptTermsOfUse).called(1);
        verify(goRouter.pop).called(1);
      },
    );
  });
}
