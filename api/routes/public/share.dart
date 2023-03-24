import 'dart:convert';
import 'dart:io';

import 'package:api/templates/templates.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final cardId = context.request.uri.queryParameters['cardId'];

  if (cardId == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  final card = await context.read<CardsRepository>().getCard(cardId);

  if (card == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  const meta = TemplateMetadata(
    title: '',
    description: '',
    shareUrl: '',
    favIconUrl: '',
    ga: '',
  );

  return Response.bytes(
    body: utf8.encode(
      buildShareCardTemplate(
        card: card,
        meta: meta,
      ),
    ),
    headers: {
      HttpHeaders.contentTypeHeader: ContentType.html.toString(),
    },
  );
}
