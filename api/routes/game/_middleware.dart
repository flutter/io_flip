import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:gcp/gcp.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:prompt_repository/prompt_repository.dart';
import 'package:scripts_repository/scripts_repository.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import '../../main.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Logger>((_) => Logger.root))
      .use(fromShelfMiddleware(cloudLoggingMiddleware(projectId)))
      .use(provider<CardsRepository>((_) => cardsRepository))
      .use(provider<PromptRepository>((_) => promptRepository))
      .use(provider<MatchRepository>((_) => matchRepository))
      .use(provider<ScriptsRepository>((_) => scriptsRepository))
      .use(provider<LeaderboardRepository>((_) => leaderboardRepository))
      .use(provider<GameScriptMachine>((_) => gameScriptMachine))
      .use(jwtMiddleware.middleware)
      .use(encryptionMiddleware.middleware)
      .use(
        fromShelfMiddleware(
          corsHeaders(
            headers: {
              ACCESS_CONTROL_ALLOW_ORIGIN: gameUrl.url,
            },
          ),
        ),
      )
      .use(_allowHeader());
}

Middleware _allowHeader() {
  return (handler) {
    return (context) async {
      final response = await handler(context);
      final headers = Map<String, String>.from(response.headers);
      final accessControlAllowHeaders = headers[ACCESS_CONTROL_ALLOW_HEADERS];
      if (accessControlAllowHeaders != null) {
        headers[ACCESS_CONTROL_ALLOW_HEADERS] =
            '$accessControlAllowHeaders, X-Firebase-AppCheck';

        return response.copyWith(headers: headers);
      }

      return response;
    };
  };
}
