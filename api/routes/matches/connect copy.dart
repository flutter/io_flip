import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:match_repository/match_repository.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  final matchRepository = context.read<MatchRepository>();
  final match = context.request.uri.queryParameters['matchId'];
  final host = context.request.uri.queryParameters['host'];

  final handler = webSocketHandler((channel, protocol) {
    host == 'true'
        ? matchRepository.setHostConnectivity(match: match!, active: true)
        : matchRepository.setGuestConnectivity(match: match!, active: true);
    channel.stream.listen(
      (_) {},
      onDone: () {
        host == 'true'
            ? matchRepository.setHostConnectivity(match: match, active: false)
            : matchRepository.setGuestConnectivity(match: match, active: false);
      },
    );
  });
  return handler(context);
}
