import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash/prompt/prompt.dart';
import 'package:top_dash/scripts/scripts.dart';
import 'package:top_dash/share/share.dart';

GoRouter createRouter({required bool isScriptsEnabled}) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: MainMenuScreen.routeBuilder,
        routes: [
          GoRoute(
            path: 'draft',
            builder: DraftPage.routeBuilder,
          ),
          GoRoute(
            path: 'prompt',
            builder: PromptPage.routeBuilder,
          ),
          GoRoute(
            name: 'match_making',
            path: 'match_making',
            builder: MatchMakingPage.routeBuilder,
          ),
          GoRoute(
            name: 'game',
            path: 'game',
            builder: GamePage.routeBuilder,
          ),
          GoRoute(
            name: 'share_hand',
            path: 'share_hand',
            builder: ShareHandPage.routeBuilder,
          ),
          if (isScriptsEnabled)
            GoRoute(
              name: '_super_secret_scripts_page',
              path: '_super_secret_scripts_page',
              builder: ScriptsPage.routeBuilder,
            ),
        ],
      ),
    ],
  );
}
