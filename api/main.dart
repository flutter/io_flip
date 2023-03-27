import 'dart:io';

import 'package:api/game_url.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:encryption_middleware/encryption_middleware.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:scripts_repository/scripts_repository.dart';

late CardsRepository cardsRepository;
late MatchRepository matchRepository;
late ScriptsRepository scriptsRepository;
late LeaderboardRepository leaderboardRepository;
late DbClient dbClient;
late GameScriptMachine gameScriptMachine;
late JwtMiddleware jwtMiddleware;
late EncryptionMiddleware encryptionMiddleware;
late GameUrl gameUrl;

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  const imageModelRepository = ImageModelRepository();
  const languageModelRepository = LanguageModelRepository();
  jwtMiddleware = JwtMiddleware(
    projectId: _appId,
    isEmulator: _useEmulator,
  );
  encryptionMiddleware = const EncryptionMiddleware();

  final dbClient = DbClient.initialize(_appId, useEmulator: _useEmulator);

  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  cardsRepository = CardsRepository(
    imageModelRepository: imageModelRepository,
    languageModelRepository: languageModelRepository,
    dbClient: dbClient,
  );

  scriptsRepository = ScriptsRepository(dbClient: dbClient);
  final initialScript = await scriptsRepository.getCurrentScript();

  gameScriptMachine = GameScriptMachine.initialize(initialScript);

  matchRepository = MatchRepository(
    cardsRepository: cardsRepository,
    dbClient: dbClient,
    matchSolver: MatchSolver(gameScriptMachine: gameScriptMachine),
  );

  leaderboardRepository = LeaderboardRepository(
    dbClient: dbClient,
    blacklistDocumentId: 'MdOoZMhusnJTcwfYE0nL',
  );

  gameUrl = GameUrl(_gameUrl);

  return serve(
    handler,
    ip,
    port,
  );
}

// https://a16e0900d-fe2c-3609-b43c-87093e447b78.web.app/

String get _appId {
  final value = Platform.environment['FB_APP_ID'];
  if (value == null) {
    throw ArgumentError('FB_APP_ID is required to run the API');
  }
  return value;
}

bool get _useEmulator => Platform.environment['USE_EMULATOR'] == 'true';

String get _gameUrl {
  final value = Platform.environment['GAME_URL'];
  if (value == null) {
    throw ArgumentError('GAME_URL is required to run the API');
  }
  return value;
}
