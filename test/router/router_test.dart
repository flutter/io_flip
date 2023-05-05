import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/router/router.dart';

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
