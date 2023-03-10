import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:scripts_repository/scripts_repository.dart';

late CardsRepository cardsRepository;
late MatchRepository matchRepository;
late ScriptsRepository scriptsRepository;
late DbClient dbClient;
late GameScriptMachine gameScriptMachine;

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  const imageModelRepository = ImageModelRepository();
  const languageModelRepository = LanguageModelRepository();

  final dbClient = DbClient.initialize(_appId);

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

  return serve(
    handler,
    ip,
    port,
  );
}

String get _appId {
  final value = Platform.environment['FB_APP_ID'];
  if (value == null) {
    throw ArgumentError('FB_APP_ID is required to run the API');
  }
  return value;
}
