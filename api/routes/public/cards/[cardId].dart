import 'dart:async';
import 'dart:io';

import 'package:card_renderer/card_renderer.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String cardId) {
  if (context.request.method == HttpMethod.get) {
    return _getCardImage(context, cardId);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

FutureOr<Response> _getCardImage(RequestContext context, String cardId) async {
  final card = await context.read<CardsRepository>().getCard(cardId);
  if (card == null) {
    return Response(statusCode: HttpStatus.notFound);
  }
  final image = await context.read<CardRenderer>().renderCard(card);

  return Response.bytes(
    body: image,
    headers: {
      HttpHeaders.contentTypeHeader: 'image/png',
    },
  );
}
