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

  late String content;
  late String header;
  late String metaImage;

  if (cardId != null) {
    final card = await context.read<CardsRepository>().getCard(cardId);
    if (card == null) {
      return Response(statusCode: HttpStatus.notFound);
    }
    header = 'Check out my card from I/O Bash!';
    content = buildShareCardContent(card: card);
    metaImage = card.image;
  } else if (deckId != null) {
    final scoreCard = await context
        .read<LeaderboardRepository>()
        .findScoreCardByLongestStreakDeck(
          deckId,
        );
    header = 'Check out my hand from I/O Bash!';
    content = buildHandContent(
      // TODO(erickzanardo): add image when the share image task is done.
      handImage: '',
      initials: 'AAA',
      streak: scoreCard?.longestStreak.toString() ?? '0',
    );
    metaImage = '';
  } else {
    return Response(statusCode: HttpStatus.notFound);
  }

  final meta = TemplateMetadata(
    title: '',
    description: '',
    shareUrl: '',
    favIconUrl: '',
    ga: '',
    gameUrl: context.read<GameUrl>().url,
    image: metaImage,
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
