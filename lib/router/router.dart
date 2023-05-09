import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/draft/draft.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/main_menu/main_menu_screen.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip/scripts/scripts.dart';
import 'package:io_flip/share/share.dart';

GoRouter createRouter({required bool isScriptsEnabled}) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => NoTransitionPage(
          child: MainMenuScreen.routeBuilder(context, state),
        ),
      ),
      GoRoute(
        path: '/draft',
        pageBuilder: (context, state) => NoTransitionPage(
          child: DraftPage.routeBuilder(context, state),
        ),
      ),
      GoRoute(
        path: '/prompt',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PromptPage.routeBuilder(context, state),
        ),
      ),
      GoRoute(
        name: 'match_making',
        path: '/match_making',
        pageBuilder: (context, state) => NoTransitionPage(
          child: MatchMakingPage.routeBuilder(context, state),
        ),
      ),
      GoRoute(
        name: 'game',
        path: '/game',
        pageBuilder: (context, state) => NoTransitionPage(
          child: GamePage.routeBuilder(context, state),
        ),
      ),
      GoRoute(
        name: 'share_hand',
        path: '/share_hand',
        pageBuilder: (context, state) => NoTransitionPage(
          child: ShareHandPage.routeBuilder(context, state),
        ),
      ),
      if (isScriptsEnabled)
        GoRoute(
          name: '_super_secret_scripts_page',
          path: '/_super_secret_scripts_page',
          builder: ScriptsPage.routeBuilder,
        ),
    ],
    observers: [RedirectToHomeObserver()],
  );
}

class RedirectToHomeObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (previousRoute == null && route.settings.name != '/') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = route.navigator!.context;
        GoRouter.of(context).go('/');
      });
    }
  }
}
