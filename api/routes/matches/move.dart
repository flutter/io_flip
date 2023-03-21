// TODO(erickzanardo): Change for this endpoint to be
// /matches/[matchId]/move/[cardId] after #33 is merged,
// keeping as this for now in the draft to avoid conflicts
// with that PR.

import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final matchId = context.request.uri.queryParameters['matchId'];
    final cardId = context.request.uri.queryParameters['cardId'];
    final deckId = context.request.uri.queryParameters['deckId'];
    if (matchId == null || cardId == null || deckId == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final matchRepository = context.read<MatchRepository>();
    final user = context.read<AuthenticatedUser>();

    try {
      await matchRepository.playCard(
        matchId: matchId,
        cardId: cardId,
        deckId: deckId,
        userId: user.id,
      );
    } catch (e, s) {
      context.read<Logger>().severe('Error playing a move', e, s);
      return Response(statusCode: HttpStatus.internalServerError);
    }

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
