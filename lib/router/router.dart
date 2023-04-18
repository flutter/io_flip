import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/game/views/card_inspector.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash/prompt/prompt.dart';
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
            path: 'settings',
            builder: SettingsScreen.routeBuilder,
          ),
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
            name: 'card_inspector',
            path: 'card_inspector',
            builder: CardInspector.routeBuilder,
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
