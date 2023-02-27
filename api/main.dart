import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firedart.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';

late CardsRepository cardsRepository;

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  const imageModelRepository = ImageModelRepository();
  const languageModelRepository = LanguageModelRepository();

  Firestore.initialize('top-dash-dev');

  cardsRepository = CardsRepository(
    imageModelRepository: imageModelRepository,
    languageModelRepository: languageModelRepository,
    firestore: Firestore.instance,
  );

  return serve(
    handler,
    ip,
    port,
  );
}
