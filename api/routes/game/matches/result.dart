import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.patch) {
    final matchRepository = context.read<MatchRepository>();

    try {
      final body =
          jsonDecode(await context.request.body()) as Map<String, dynamic>;
      final match = Match.fromJson(body['match'] as Map<String, dynamic>);
      final matchState =
          MatchState.fromJson(body['matchState'] as Map<String, dynamic>);

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
