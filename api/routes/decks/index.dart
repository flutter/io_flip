import 'dart:async';
import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final json = await context.request.json() as Map<String, dynamic>;
    final cards = json['cards'];

    if (cards is! List<String>) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final cardsRepository = context.read<CardsRepository>();
    final deckId = await cardsRepository.createDeck(cards);
    return Response.json(body: { 'id': deckId });
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
