import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:game_domain/game_domain.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context, String matchId) async {
  if (context.request.method == HttpMethod.post) {
    final user = context.read<AuthenticatedUser>();
    final matchRepository = context.read<MatchRepository>();
    final matchId = context.request.uri.queryParameters['matchId']!;

    final playerConnected = await matchRepository.getPlayerConnectivity(
      isHost: true,
      matchId: matchId,
    );

    if (playerConnected) {
      final handler = webSocketHandler((channel, protocol) async {
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
        } catch (e) {
          channel.sink.add(
            jsonEncode(
              const WebSocketMessage(
                error: ErrorType.firebaseException,
              ).toJson(),
            ),
          );
        }
        channel.stream.listen(
          null,
          onDone: () {
            matchRepository.setCpuConnectivity(match: matchId, hostId: user.id);
          },
        );
      });
      return handler(context);
    } else {
      final playerNotConnectedHandler = webSocketHandler((
        channel,
        protocol,
      ) {
        const message = WebSocketMessage(
          error: ErrorType.playerNotConnectedToGame,
        );
        final json = jsonEncode(message);
        channel.sink.add(json);
      });

      return playerNotConnectedHandler(context);
    }
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
