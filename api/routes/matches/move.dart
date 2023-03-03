// TODO(erickzanardo): Change for this endpoint to be
// /matches/[matchId]/move/[cardId] after #33 is merged,
// keeping as this for now in the draft to avoid conflicts
// with that PR.

import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final matchId = context.request.uri.queryParameters['matchId'];
    final cardId = context.request.uri.queryParameters['cardId'];
    final host = context.request.uri.queryParameters['host'];
    if (matchId == null || cardId == null || host == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final matchRepository = context.read<MatchRepository>();
    try {
      await matchRepository.playCard(
        matchId: matchId,
        cardId: cardId,
        isHost: host == 'true',
      );
    } catch (e, s) {
      context.read<Logger>().severe('Error playing a move, $e \n$s');
      return Response(statusCode: HttpStatus.internalServerError);
    }

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
