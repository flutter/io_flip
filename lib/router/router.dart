import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash/settings/settings_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainMenuScreen(
          key: Key('main menu'),
        ),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(
              key: Key('settings'),
            ),
          ),
          GoRoute(
            path: 'draft',
            builder: (context, state) => const DraftPage(
              key: Key('draft'),
            ),
          ),
          GoRoute(
            path: 'match_making',
            builder: (context, state) => const MatchMakingPage(
              key: Key('match_making'),
            ),
          ),
        ],
      ),
    ],
  );
}
