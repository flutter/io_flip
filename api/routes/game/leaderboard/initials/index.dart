import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final json = await context.request.json() as Map<String, dynamic>;
    final scoreCardId = json['scoreCardId'];
    final initials = json['initials'];

    if (scoreCardId is! String || initials is! String) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final leaderboardRepository = context.read<LeaderboardRepository>();

    final initialsAvailability =
        await leaderboardRepository.isInitialsAvailable(initials);

    if (!initialsAvailability) {
      return Response(
        statusCode: HttpStatus.conflict,
        body: '"$initials" is already taken.',
      );
    }

    await leaderboardRepository.addInitialsToScoreCard(
      scoreCardId: scoreCardId,
      initials: initials,
    );

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
