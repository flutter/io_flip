import 'dart:async';
import 'dart:io';

import 'package:card_renderer/card_renderer.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';

FutureOr<Response> onRequest(RequestContext context, String deckId) {
  if (context.request.method == HttpMethod.get) {
    return _getDeckImage(context, deckId);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

FutureOr<Response> _getDeckImage(RequestContext context, String deckId) async {
  final cardsRepository = context.read<CardsRepository>();
  final deck = await cardsRepository.getDeck(deckId);

  if (deck == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  if (deck.shareImage != null) {
    return Response(
      statusCode: HttpStatus.movedPermanently,
      headers: {
        HttpHeaders.locationHeader: deck.shareImage!,
      },
    );
  }

  final image = await context.read<CardRenderer>().renderDeck(deck.cards);

  final firebaseCloudStorage = context.read<FirebaseCloudStorage>();
  final url = await firebaseCloudStorage.uploadFile(
    image,
    'share/$deckId.png',
  );

  final newDeck = deck.copyWithShareImage(url);
  // Intentionally not waiting for this update to complete so this
  // doesn't block the response.
  unawaited(cardsRepository.updateDeck(newDeck));

  return Response.bytes(
    body: image,
    headers: {
      HttpHeaders.contentTypeHeader: 'image/png',
    },
  );
}
