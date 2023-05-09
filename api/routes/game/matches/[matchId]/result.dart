import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context, String matchId) async {
  if (context.request.method == HttpMethod.patch) {
    final matchRepository = context.read<MatchRepository>();

    try {
      final match = await matchRepository.getMatch(matchId);
      final matchState = await matchRepository.getMatchState(matchId);

      if (match == null || matchState == null) {
        return Response(statusCode: HttpStatus.notFound);
      }

      await matchRepository.calculateMatchResult(
        match: match,
        matchState: matchState,
      );
    } catch (e, s) {
      context.read<Logger>().warning('Error calculating match result', e, s);
      return Response(statusCode: HttpStatus.badRequest);
    }

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
