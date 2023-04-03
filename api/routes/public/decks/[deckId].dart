import 'dart:async';
import 'dart:io';

import 'package:card_renderer/card_renderer.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String deckId) {
  if (context.request.method == HttpMethod.get) {
    return _getDeckImage(context, deckId);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

FutureOr<Response> _getDeckImage(RequestContext context, String deckId) async {
  final deck = await context.read<CardsRepository>().getDeck(deckId);

  if (deck == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  final image = await context.read<CardRenderer>().renderDeck(deck.cards);

  return Response.bytes(
    body: image,
    headers: {
      HttpHeaders.contentTypeHeader: 'image/png',
    },
  );
}
