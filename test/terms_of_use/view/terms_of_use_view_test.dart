import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:top_dash/terms_of_use/terms_of_use.dart';
import 'package:top_dash/utils/external_links.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../helpers/helpers.dart';

class _MockTermsOfUseCubit extends MockCubit<bool> implements TermsOfUseCubit {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() {
  late TermsOfUseCubit cubit;
  late UrlLauncherPlatform urlLauncher;

  setUp(() {
    cubit = _MockTermsOfUseCubit();
    when(cubit.acceptTermsOfUse).thenAnswer((_) => true);

    urlLauncher = _MockUrlLauncher();
    UrlLauncherPlatform.instance = urlLauncher;
  });

  setUpAll(() {
    registerFallbackValue(_FakeLaunchOptions());
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
        l10n.termsOfUseContinueLabel,
      ];

      for (final text in expectedTexts) {
        expect(find.text(text, findRichText: true), findsOneWidget);
      }
    });

    testWidgets(
      'tapping on Terms of Service opens the link',
      (tester) async {
        const link = ExternalLinks.termsOfService;

        when(
          () => urlLauncher.canLaunch(link),
        ).thenAnswer((_) async => true);

        when(
          () => urlLauncher.launchUrl(link, any()),
        ).thenAnswer((_) async => true);

        await tester.pumpApp(buildSubject());

        final l10n = tester.l10n;

        final textFinder = find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              tapTextSpan(widget, l10n.termsOfUseDescriptionInfixOne),
        );
        await tester.tap(textFinder);
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(link, any()),
        ).called(1);
      },
    );

    testWidgets(
      'tapping on Privacy Policy opens the link',
      (tester) async {
        const link = ExternalLinks.privacyPolicy;

        when(
          () => urlLauncher.canLaunch(link),
        ).thenAnswer((_) async => true);

        when(
          () => urlLauncher.launchUrl(link, any()),
        ).thenAnswer((_) async => true);

        await tester.pumpApp(buildSubject());

        final l10n = tester.l10n;

        final textFinder = find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              tapTextSpan(widget, l10n.termsOfUseDescriptionSuffix),
        );
        await tester.tap(textFinder);
        await tester.pumpAndSettle();

        verify(
          () => urlLauncher.launchUrl(link, any()),
        ).called(1);
      },
    );

    testWidgets(
      'tapping continue button calls acceptTermsOfUse and pops go router',
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

        await tester.tap(find.text(l10n.termsOfUseContinueLabel));
        await tester.pumpAndSettle();

        verify(cubit.acceptTermsOfUse).called(1);
        verify(goRouter.pop).called(1);
      },
    );
  });
}
