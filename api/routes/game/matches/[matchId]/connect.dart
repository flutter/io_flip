import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context, String matchId) async {
  if (context.request.method == HttpMethod.post) {
    final user = context.read<AuthenticatedUser>();
    final matchRepository = context.read<MatchRepository>();

    final playerConnected = await matchRepository.getPlayerConnectivity(
      userId: user.id,
    );

    if (playerConnected) {
      try {
        final cardsRepository = context.read<CardsRepository>();
        final cards = await Future.wait(
          List.generate(
            3,
            (_) => cardsRepository.generateCard(),
          ),
        );

        await cardsRepository.createDeck(
          cardIds: cards.map((e) => e.id).toList(),
          userId: 'CPU_${user.id}',
        );

        await matchRepository.setCpuConnectivity(
          matchId: matchId,
          hostId: user.id,
        );
      } catch (e, s) {
        log('Error while connecting to cpu match: $e', stackTrace: s);
        return Response(statusCode: HttpStatus.internalServerError);
      }
      return Response(statusCode: HttpStatus.noContent);
    } else {
      return Response(statusCode: HttpStatus.forbidden);
    }
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
