import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import '../main.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<CardsRepository>((_) => cardsRepository))
      .use(fromShelfMiddleware(corsHeaders()));
}
