import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

const _imageModelRepository = ImageModelRepository();
const _languageModelRepository = LanguageModelRepository();

final _cardsRepository = CardsRepository(
  imageModelRepository: _imageModelRepository,
  languageModelRepository: _languageModelRepository,
);

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<CardsRepository>((_) => _cardsRepository))
      .use(fromShelfMiddleware(corsHeaders()));
}
