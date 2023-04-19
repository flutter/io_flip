import 'dart:async';
import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart' as ws;
import 'package:game_domain/game_domain.dart';
import 'package:match_repository/match_repository.dart';

import '../../main.dart';

typedef WebSocketHandlerFactory = Handler Function(
  void Function(ws.WebSocketChannel channel, String? protocol) onConnection,
);

Future<Response> onRequest(RequestContext context) async {
  final matchRepository = context.read<MatchRepository>();
  final webSocketHandlerFactory = context.read<WebSocketHandlerFactory>();

  final handler = webSocketHandlerFactory((channel, protocol) {
    String? userId;
    String? matchId;
    var isHost = true;
    Future<void> setConnectivity({required bool connected}) async {
      if (userId != null) {
        await matchRepository.setPlayerConnectivity(
          userId: userId!,
          connected: connected,
        );
      }
    }

    Future<void> setGameConnectivity({required bool connected}) async {
      if (matchId != null) {
        if (isHost) {
          await matchRepository.setHostConnectivity(
            match: matchId!,
            active: connected,
          );
        } else {
          await matchRepository.setGuestConnectivity(
            match: matchId!,
            active: connected,
          );
        }
      }
    }

    Future<void> handleMessage(WebSocketMessage message) async {
      if (message.messageType == MessageType.token) {
        final tokenPayload = message.payload! as WebSocketTokenPayload;
        final newUserId = await jwtMiddleware.verifyToken(tokenPayload.token);

        if (newUserId != userId) {
          if (userId != null) {
            // Disconnect the old user.
            await matchRepository.setPlayerConnectivity(
              userId: userId!,
              connected: false,
            );
          }
          userId = newUserId;
          if (userId != null) {
            final isConnected = await matchRepository.getPlayerConnectivity(
              userId: userId!,
            );

            if (isConnected && !tokenPayload.reconnect) {
              final message = WebSocketMessage.error(
                WebSocketErrorCode.playerAlreadyConnected,
              );
              channel.sink.add(jsonEncode(message));
              userId = null;
            } else if (!isConnected) {
              try {
                await setConnectivity(connected: true);
                channel.sink
                    .add(jsonEncode(const WebSocketMessage.connected()));
              } catch (e) {
                channel.sink.add(
                  jsonEncode(
                    WebSocketMessage.error(
                      WebSocketErrorCode.firebaseException,
                    ),
                  ),
                );
              }
            } else if (isConnected) {
              channel.sink.add(jsonEncode(const WebSocketMessage.connected()));
            }
          }
        }
      } else {
        // All other message types require a user to already be authenticated.
        if (userId != null) {
          if (message.messageType == MessageType.matchJoined) {
            final matchJoinedPayload =
                message.payload! as WebSocketMatchJoinedPayload;
            await setGameConnectivity(connected: false);
            matchId = matchJoinedPayload.matchId;
            isHost = matchJoinedPayload.isHost;
            await setGameConnectivity(connected: true);
            channel.sink.add(
              jsonEncode(
                WebSocketMessage.matchJoined(
                  isHost: isHost,
                  matchId: matchId!,
                ),
              ),
            );
          } else if (message.messageType == MessageType.matchLeft) {
            await setGameConnectivity(connected: false);
            matchId = null;
          }
        }
      }
    }

    channel.stream.listen(
      (data) async {
        if (data is String) {
          final decoded = jsonDecode(data);
          if (decoded is Map) {
            try {
              final message = WebSocketMessage.fromJson(
                Map<String, dynamic>.from(decoded),
              );
              await handleMessage(message);
            } catch (e) {
              // ignore this message.
            }
          }
        }
      },
      onDone: () {
        setConnectivity(connected: false);
        setGameConnectivity(connected: false);
      },
    );
  });

  return handler(context);
}
