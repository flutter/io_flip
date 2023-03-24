import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../../routes/matches/connect.dart' as route;

class _MockMatchRepository extends Mock implements MatchRepository {}

void main() {
  late HttpServer server;
  late MatchRepository matchRepository;

  const match = 'matchId';

  group('GET /matches/connect', () {
    setUp(() {
      matchRepository = _MockMatchRepository();
    });

    test('establishes connection and updates player connectivity', () async {
      when(
        () => matchRepository.setHostConnectivity(
          match: match,
          active: any<bool>(named: 'active'),
        ),
      ).thenAnswer(
        (_) async {},
      );

      server = await serve(
        (context) => route.onRequest(
          context.provide<MatchRepository>(() => matchRepository),
        ),
        InternetAddress.anyIPv4,
        0,
      );
      final socket = WebSocket(
        Uri.parse('ws://localhost:${server.port}?matchId=$match&host=true'),
      );

      await untilCalled(
        () => matchRepository.setHostConnectivity(match: match, active: true),
      );
      verify(
        () => matchRepository.setHostConnectivity(match: match, active: true),
      ).called(1);

      await expectLater(
        socket.messages,
        emits(
          jsonEncode(const WebSocketMessage(message: 'Connected').toJson()),
        ),
      );

      socket.close();

      await untilCalled(
        () => matchRepository.setHostConnectivity(match: match, active: false),
      );
      verify(
        () => matchRepository.setHostConnectivity(match: match, active: false),
      ).called(1);
    });

    test('throws when cannot update player connectivity', () async {
      when(
        () => matchRepository.setHostConnectivity(
          match: match,
          active: any<bool>(named: 'active'),
        ),
      ).thenThrow(Exception('oops'));

      server = await serve(
        (context) => route.onRequest(
          context.provide<MatchRepository>(() => matchRepository),
        ),
        InternetAddress.anyIPv4,
        0,
      );
      final socket = WebSocket(
        Uri.parse('ws://localhost:${server.port}?matchId=$match&host=true'),
      );

      await untilCalled(
        () => matchRepository.setHostConnectivity(match: match, active: true),
      );
      verify(
        () => matchRepository.setHostConnectivity(match: match, active: true),
      ).called(1);

      await expectLater(
        socket.messages,
        emits(
          jsonEncode(
            const WebSocketMessage(
              message: 'Unable to set player connectivity',
              error: ErrorType.firebaseException,
            ).toJson(),
          ),
        ),
      );

      socket.close();
    });
  });
}
