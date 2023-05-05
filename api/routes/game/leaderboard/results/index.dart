import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    final leaderboardRepository = context.read<LeaderboardRepository>();

    final leaderboardPlayers = await leaderboardRepository.getLeaderboard();

    return Response.json(
      body: {
        'leaderboardPlayers': leaderboardPlayers
            .map(
              (player) => player.toJson(),
            )
            .toList(),
      },
    );
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
