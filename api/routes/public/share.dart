import 'dart:convert';
import 'dart:io';

import 'package:api/game_url.dart';
import 'package:api/templates/templates.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final cardId = context.request.uri.queryParameters['cardId'];
  final deckId = context.request.uri.queryParameters['deckId'];
  final gameUrl = context.read<GameUrl>().url;

  late String content;
  late String header;
  final String metaImagePath;
  final redirectResponse = Response(
    statusCode: HttpStatus.movedPermanently,
    headers: {
      HttpHeaders.locationHeader: gameUrl,
    },
  );

  if (cardId != null) {
    final card = await context.read<CardsRepository>().getCard(cardId);
    if (card == null) {
      return redirectResponse;
    }
    header = 'Check out my card from I/O FLIP!';
    content = buildShareCardContent(card: card);
    metaImagePath = '/public/cards/$cardId';
  } else if (deckId != null) {
    final scoreCard = await context
        .read<LeaderboardRepository>()
        .findScoreCardByLongestStreakDeck(
          deckId,
        );
    if (scoreCard == null) {
      return redirectResponse;
    }
    header = 'Check out my hand from I/O FLIP!';
    content = buildHandContent(
      handImage: '/public/decks/$deckId',
      initials: scoreCard.initials ?? '',
      streak: scoreCard.longestStreak.toString(),
    );
    metaImagePath = '/public/decks/$deckId';
  } else {
    return redirectResponse;
  }

  final meta = TemplateMetadata(
    title: header,
    description: '',
    shareUrl: context.request.uri.toString(),
    favIconUrl: '',
    ga: '',
    gameUrl: gameUrl,
    image: context.request.uri.replace(
      path: metaImagePath,
      queryParameters: {},
    ).toString(),
  );

  return Response.bytes(
    body: utf8.encode(
      buildShareTemplate(
        content: content,
        header: header,
        meta: meta,
      ),
    ),
    headers: {
      HttpHeaders.contentTypeHeader: ContentType.html.toString(),
    },
  );
}
