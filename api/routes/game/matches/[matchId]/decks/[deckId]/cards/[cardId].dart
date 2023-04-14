import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:gcloud/pubsub.dart';
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

      final topic = await pubsubService.createTopic('playCard');

      await topic.publish(Message.withString('message', attributes: {
        'matchId': matchId,
        'cardId': cardId,
        'deckId': deckId,
      }));
    } catch (e, s) {
      context.read<Logger>().severe('Error playing a move', e, s);
      rethrow;
    }

    return Response(statusCode: HttpStatus.noContent);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
