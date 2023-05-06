import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(
  RequestContext context,
  String matchId,
  String deckId,
  String cardId,
) async {
  if (context.request.method == HttpMethod.post) {
    final matchRepository = context.read<MatchRepository>();
    final user = context.read<AuthenticatedUser>();

    try {
      await matchRepository.playCard(
        matchId: matchId,
        cardId: cardId,
        deckId: deckId,
        userId: user.id,
      );
    } on MatchNotFoundFailure {
      return Response(statusCode: HttpStatus.notFound);
    } on PlayCardFailure {
      return Response(statusCode: HttpStatus.badRequest);
    } catch (e, s) {
      context.read<Logger>().severe('Error playing a move', e, s);
      rethrow;
    }

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
