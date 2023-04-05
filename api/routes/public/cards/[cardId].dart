import 'dart:async';
import 'dart:io';

import 'package:card_renderer/card_renderer.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';

FutureOr<Response> onRequest(RequestContext context, String cardId) {
  if (context.request.method == HttpMethod.get) {
    return _getCardImage(context, cardId);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}

FutureOr<Response> _getCardImage(RequestContext context, String cardId) async {
  final cardRepository = context.read<CardsRepository>();
  final card = await cardRepository.getCard(cardId);
  if (card == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  if (card.shareImage != null) {
    return Response(
      statusCode: HttpStatus.movedPermanently,
      headers: {
        HttpHeaders.locationHeader: card.shareImage!,
      },
    );
  }

  final image = await context.read<CardRenderer>().renderCard(card);

  final firebaseCloudStorage = context.read<FirebaseCloudStorage>();

  final url = await firebaseCloudStorage.updloadFile(
    image,
    'share/$cardId.png',
  );

  final newCard = card.copyWithShareImage(url);
  // Intentionally not waiting for this update to complete so this
  // doesn't block the response.
  unawaited(cardRepository.updateCard(newCard));

  return Response.bytes(
    body: image,
    headers: {
      HttpHeaders.contentTypeHeader: 'image/png',
    },
  );
}
