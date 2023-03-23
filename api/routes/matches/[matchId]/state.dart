import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context, String matchId) async {
  if (context.request.method == HttpMethod.get) {
    final matchRepository = context.read<MatchRepository>();
    final matchState = await matchRepository.getMatchState(matchId);

    if (matchState == null) {
      return Response(statusCode: HttpStatus.notFound);
    }

    return Response.json(body: matchState.toJson());
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
