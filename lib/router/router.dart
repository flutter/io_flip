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
        builder: MainMenuScreen.routeBuilder,
      ),
      GoRoute(
        path: '/draft',
        builder: DraftPage.routeBuilder,
      ),
      GoRoute(
        path: '/prompt',
        builder: PromptPage.routeBuilder,
      ),
      GoRoute(
        name: 'match_making',
        path: '/match_making',
        builder: MatchMakingPage.routeBuilder,
      ),
      GoRoute(
        name: 'game',
        path: '/game',
        builder: GamePage.routeBuilder,
      ),
      GoRoute(
        name: 'share_hand',
        path: '/share_hand',
        builder: ShareHandPage.routeBuilder,
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
