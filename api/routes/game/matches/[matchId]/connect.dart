import 'dart:async';
import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:logging/logging.dart';
import 'package:match_repository/match_repository.dart';
import 'package:prompt_repository/prompt_repository.dart';

FutureOr<Response> onRequest(RequestContext context, String matchId) async {
  if (context.request.method == HttpMethod.post) {
    final user = context.read<AuthenticatedUser>();
    final matchRepository = context.read<MatchRepository>();

    final playerConnected = await matchRepository.getPlayerConnectivity(
      userId: user.id,
    );

    if (playerConnected || !matchRepository.trackPlayerPresence) {
      try {
        final cardsRepository = context.read<CardsRepository>();
        final promptRepository = context.read<PromptRepository>();

        final [classes, powers] = await Future.wait([
          promptRepository.getPromptTermsByType(PromptTermType.characterClass),
          promptRepository.getPromptTermsByType(PromptTermType.power),
        ]);

        final cards = await cardsRepository.generateCards(
          characterClass: ([...classes]..shuffle()).first.term,
          characterPower: ([...powers]..shuffle()).first.term,
        );

        final hand = (cards..shuffle()).take(3).toList();

        final deckId = await cardsRepository.createDeck(
          cardIds: hand.map((e) => e.id).toList(),
          userId: 'CPU_${user.id}',
        );

        await matchRepository.setCpuConnectivity(
          matchId: matchId,
          deckId: deckId,
        );
      } catch (e, s) {
        context
            .read<Logger>()
            .warning('Error while connecting to cpu match', e, s);
        return Response(statusCode: HttpStatus.internalServerError);
      }
      return Response(statusCode: HttpStatus.noContent);
    } else {
      return Response(statusCode: HttpStatus.forbidden);
    }
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
