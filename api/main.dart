import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';

late CardsRepository cardsRepository;
late DbClient dbClient;

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  const imageModelRepository = ImageModelRepository();
  const languageModelRepository = LanguageModelRepository();

  final dbClient = DbClient.initialize(_appId);

  cardsRepository = CardsRepository(
    imageModelRepository: imageModelRepository,
    languageModelRepository: languageModelRepository,
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
