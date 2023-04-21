import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context, String matchId) async {
  if (context.request.method == HttpMethod.patch) {
    final matchRepository = context.read<MatchRepository>();

    try {
      await matchRepository.calculateMatchResult(matchId);
    } catch (e, s) {
      log('Error calculating match result: $e', stackTrace: s);
      return Response(statusCode: HttpStatus.badRequest);
    }

    return Response();
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
