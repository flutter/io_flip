// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';
import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final matchRepository = context.read<MatchRepository>();
  final matchId = context.request.uri.queryParameters['matchId']!;
  final host = context.request.uri.queryParameters['host']!;
  final isHost = host == 'true';
  final playerConnected = await matchRepository.getPlayerConnectivity(
    isHost: isHost,
    matchId: matchId,
  );

  if (playerConnected) {
    final playerAlreadyConnectedHandler = webSocketHandler((channel, protocol) {
      const message = WebSocketMessage(error: ErrorType.playerAlreadyConnected);
      final json = jsonEncode(message);
      channel.sink.add(json);
    });

    return playerAlreadyConnectedHandler(context);
  } else {
    final handler = webSocketHandler((channel, protocol) {
      try {
        isHost
            ? matchRepository.setHostConnectivity(match: matchId, active: true)
            : matchRepository.setGuestConnectivity(
                match: matchId,
                active: true,
              );
        channel.sink.add(
          jsonEncode(
            const WebSocketMessage(message: MessageType.connected).toJson(),
          ),
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
        (_) {},
        onDone: () {
          isHost
              ? matchRepository.setHostConnectivity(
                  match: matchId,
                  active: false,
                )
              : matchRepository.setGuestConnectivity(
                  match: matchId,
                  active: false,
                );
        },
      );
    });

    return handler(context);
  }
}
