import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';

late CardsRepository cardsRepository;
late MatchRepository matchRepository;
late DbClient dbClient;

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  const imageModelRepository = ImageModelRepository();
  const languageModelRepository = LanguageModelRepository();

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

  matchRepository = MatchRepository(
    cardsRepository: cardsRepository,
    dbClient: dbClient,
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

bool get _useEmulator => Platform.environment['USE_EMULATOR'] == 'true';
