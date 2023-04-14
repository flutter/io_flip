import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    final leaderboardRepository = context.read<LeaderboardRepository>();

    try {
      final scoreCardsWithMostWins =
          await leaderboardRepository.getScoreCardsWithMostWins();

      final scoreCardsWithLongestStreak =
          await leaderboardRepository.getScoreCardsWithLongestStreak();

      return Response.json(
        body: {
          'scoreCardsWithMostWins': scoreCardsWithMostWins
              .map(
                (card) => card.toJson(),
              )
              .toList(),
          'scoreCardsWithLongestStreak': scoreCardsWithLongestStreak
              .map(
                (card) => card.toJson(),
              )
              .toList(),
        },
      );
    } catch (e) {
      return Response(
        statusCode: HttpStatus.methodNotAllowed,
        body: jsonEncode(e.toString()),
      );
    }
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
