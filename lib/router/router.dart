import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/game/game_screen.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
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
            path: 'play',
            builder: (context, state) => const GameScreen(
              key: Key('settings'),
            ),
          ),
          GoRoute(
            path: 'draft',
            builder: (context, state) => const DraftPage(
              key: Key('draft'),
            ),
          ),
        ],
      ),
    ],
  );
}
