import 'dart:async';
import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final cardsRepository = context.read<CardsRepository>();
    final card = await cardsRepository.generateCard();
    return Response.json(body: card.toJson());
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
