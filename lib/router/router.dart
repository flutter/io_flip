import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash/settings/settings_screen.dart';

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
            path: 'game/:matchId/:isHost',
            builder: GamePage.routeBuilder,
          ),
        ],
      ),
    ],
  );
}
