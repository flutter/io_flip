import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/draft/draft.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/main_menu/main_menu_screen.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip/router/router.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip/terms_of_use/terms_of_use.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class _MockTermsOfUseCubit extends MockCubit<bool> implements TermsOfUseCubit {}

class _MockMatchMakingPageData extends Mock implements MatchMakingPageData {
  @override
  Deck get deck => const Deck(id: 'id', userId: 'userId', cards: []);
}

class _MockShareHandPageData extends Mock implements ShareHandPageData {
  static const card = Card(
    id: 'id',
    name: 'name',
    description: 'description',
    image: 'image',
    power: 1,
    rarity: false,
    suit: Suit.air,
  );

  @override
  Deck get deck => const Deck(
        id: 'id',
        userId: 'userId',
        cards: [card, card, card],
        shareImage: '',
      );

  @override
  String get initials => 'AAA';

  @override
  int get wins => 1;
}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('createRouter', () {
    test('adds the script page when isScriptsEnabled is true', () {
      try {
        createRouter(isScriptsEnabled: true).goNamed(
          '_super_secret_scripts_page',
        );
      } catch (_) {
        fail('Should not throw an exception');
      }
    });

    test("doesn't adds the scripts page when isScriptsEnabled is false", () {
      expect(
        () => createRouter(isScriptsEnabled: false)
            .goNamed('_super_secret_scripts_page'),
        throwsAssertionError,
      );
    });

    group('Router', () {
      late TermsOfUseCubit cubit;
      late GoRouter router;

      setUp(() {
        router = createRouter(isScriptsEnabled: false);
        cubit = _MockTermsOfUseCubit();
        when(() => cubit.state).thenReturn(true);
      });

      testWidgets(
        'default route is MainMenuScreen',
        (tester) async {
          await tester.pumpAppWithRouter(router, termsOfUseCubit: cubit);

          expect(find.byType(MainMenuScreen), findsOneWidget);
        },
      );

      testWidgets(
        'navigating to /draft should build DraftPage',
        (tester) async {
          await tester.pumpAppWithRouter(router, termsOfUseCubit: cubit);

          router.go('/draft');

          await tester.pumpAndSettle();

          expect(find.byType(DraftPage), findsOneWidget);
        },
      );

      testWidgets(
        'navigating to /prompt should build PromptPage',
        (tester) async {
          await tester.pumpAppWithRouter(router, termsOfUseCubit: cubit);

          router.go('/prompt');

          await tester.pumpAndSettle();

          expect(find.byType(PromptPage), findsOneWidget);
        },
      );

      testWidgets(
        'navigating to /match_making should build MatchMakingPage',
        (tester) async {
          final SettingsController settingsController =
              _MockSettingsController();

          await tester.pumpAppWithRouter(
            router,
            termsOfUseCubit: cubit,
            settingsController: settingsController,
          );

          router.go('/match_making', extra: _MockMatchMakingPageData());

          await tester.pumpAndSettle();

          expect(find.byType(MatchMakingPage), findsOneWidget);
        },
      );

      testWidgets(
        'navigating to /game should build GamePage',
        (tester) async {
          await tester.pumpAppWithRouter(router, termsOfUseCubit: cubit);

          router.go('/game');

          await tester.pumpAndSettle();

          expect(find.byType(GamePage), findsOneWidget);
        },
      );

      testWidgets(
        'navigating to /share_hand should build ShareHandPage',
        (tester) async {
          final SettingsController settingsController =
              _MockSettingsController();

          await tester.pumpAppWithRouter(
            router,
            termsOfUseCubit: cubit,
            settingsController: settingsController,
          );

          router.go('/share_hand', extra: _MockShareHandPageData());

          await tester.pumpAndSettle();

          expect(find.byType(ShareHandPage), findsOneWidget);
        },
      );
    });

    group('RedirectToHomeObserver', () {
      testWidgets(
        'redirects to root when the first route is not the root route',
        (tester) async {
          final router = GoRouter(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => MaterialPage(
                  child: _MainWidget(),
                ),
              ),
              GoRoute(
                path: '/other-page',
                pageBuilder: (context, state) => MaterialPage(
                  child: _OtherWidget(),
                ),
              ),
            ],
            observers: [RedirectToHomeObserver()],
          );

          final app = MaterialApp.router(
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
          );

          await tester.pumpWidget(app);

          router.go('/other-page');

          await tester.pumpAndSettle();

          expect(find.byType(_MainWidget), findsOneWidget);
          expect(find.byType(_OtherWidget), findsNothing);
        },
      );
    });
  });
}

class _MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _OtherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
