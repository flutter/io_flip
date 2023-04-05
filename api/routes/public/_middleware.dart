import 'package:api/game_url.dart';
import 'package:card_renderer/card_renderer.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart' as ws;
import 'package:game_script_machine/game_script_machine.dart';
import 'package:gcp/gcp.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:prompt_repository/prompt_repository.dart';
import 'package:scripts_repository/scripts_repository.dart';

import '../../main.dart';
import 'matches/connect.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<Logger>((_) => Logger.root))
      .use(fromShelfMiddleware(cloudLoggingMiddleware(projectId)))
      .use(provider<CardsRepository>((_) => cardsRepository))
      .use(provider<MatchRepository>((_) => matchRepository))
      .use(provider<PromptRepository>((_) => promptRepository))
      .use(provider<ScriptsRepository>((_) => scriptsRepository))
      .use(provider<LeaderboardRepository>((_) => leaderboardRepository))
      .use(provider<GameScriptMachine>((_) => gameScriptMachine))
      .use(provider<GameUrl>((_) => gameUrl))
      .use(provider<CardRenderer>((_) => CardRenderer()))
      .use(
        provider<FirebaseCloudStorage>(
          (_) => const FirebaseCloudStorage(
            bucketName: 'top-dash-dev.appspot.com',
          ),
        ),
      );
      .use(provider<WebSocketHandlerFactory>((_) => ws.webSocketHandler));
}
