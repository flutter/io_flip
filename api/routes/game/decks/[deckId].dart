import 'dart:async';
import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String deckId) {
  if (context.request.method == HttpMethod.get) {
    return _getDeck(context, deckId);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

FutureOr<Response> _getDeck(RequestContext context, String deckId) async {
  final cardsRepository = context.read<CardsRepository>();

  final deck = await cardsRepository.getDeck(deckId);

  if (deck == null) {
    return Response(statusCode: 404);
  }

  return Response.json(body: deck.toJson());
}
