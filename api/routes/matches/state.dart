// TODO(erickzanardo): Change for this endpoint to be
// /matches/[matchId]/state after #33 is merged,
// keeping as this for now in the draft to avoid conflicts
// with that PR.

import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    final matchId = context.request.uri.queryParameters['matchId'];
    if (matchId == null) {
      return Response(statusCode: HttpStatus.notFound);
    }

    final matchRepository = context.read<MatchRepository>();
    final matchState = await matchRepository.getMatchState(matchId);

    if (matchState == null) {
      return Response(statusCode: HttpStatus.notFound);
    }

    return Response.json(body: matchState.toJson());
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
