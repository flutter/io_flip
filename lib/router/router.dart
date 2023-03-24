import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash/scripts/scripts.dart';
import 'package:top_dash/settings/settings_screen.dart';
import 'package:top_dash/share/share.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: MainMenuScreen.routeBuilder,
        routes: [
          GoRoute(
            path: 'how_to_play',
            builder: HowToPlayPage.routeBuilder,
          ),
          GoRoute(
            path: 'settings',
            builder: SettingsScreen.routeBuilder,
            routes: [
              GoRoute(
                path: 'how_to_play',
                builder: HowToPlayPage.routeBuilder,
              ),
            ],
          ),
          GoRoute(
            path: 'draft',
            builder: DraftPage.routeBuilder,
          ),
          GoRoute(
            name: 'match_making',
            path: 'match_making',
            builder: MatchMakingPage.routeBuilder,
          ),
          GoRoute(
            name: 'game',
            path: 'game/:matchId',
            builder: GamePage.routeBuilder,
          ),
          GoRoute(
            name: 'share',
            path: 'share',
            builder: SharePage.routeBuilder,
          ),
          GoRoute(
            path: '_super_secret_scripts_page',
            builder: ScriptsPage.routeBuilder,
          ),
        ],
      ),
    ],
  );
}
