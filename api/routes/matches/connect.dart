import 'dart:async';
import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final matchRepository = context.read<MatchRepository>();
  final match = context.request.uri.queryParameters['matchId'];
  final host = context.request.uri.queryParameters['host'];

  final handler = webSocketHandler((channel, protocol) {
    try {
      host == 'true'
          ? matchRepository.setHostConnectivity(match: match!, active: true)
          : matchRepository.setGuestConnectivity(match: match!, active: true);
      channel.sink.add(
        jsonEncode(const WebSocketMessage(message: 'Connected').toJson()),
      );
    } catch (e) {
      channel.sink.add(
        jsonEncode(
          const WebSocketMessage(
            message: 'Unable to set player connectivity',
            error: ErrorType.firebaseException,
          ).toJson(),
        ),
      );
    }
    channel.stream.listen(
      (_) {},
      onDone: () {
        host == 'true'
            ? matchRepository.setHostConnectivity(match: match!, active: false)
            : matchRepository.setGuestConnectivity(
                match: match!,
                active: false,
              );
      },
    );
  });
  return handler(context);
}
