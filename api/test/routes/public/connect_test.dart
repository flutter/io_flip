import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../../routes/public/matches/connect.dart' as route;

class _MockMatchRepository extends Mock implements MatchRepository {}

void main() {
  late HttpServer server;
  late MatchRepository matchRepository;

  const matchId = 'matchId';

  Future<WebSocket> startSocket() async {
    server = await serve(
      (context) => route.onRequest(
        context.provide<MatchRepository>(() => matchRepository),
      ),
      InternetAddress.anyIPv4,
      0,
    );
    final socket = WebSocket(
      Uri.parse('ws://localhost:${server.port}?host=true&matchId=$matchId'),
    );
    return socket;
  }

  group('GET /matches/connect', () {
    setUp(() {
      matchRepository = _MockMatchRepository();
    });

    test('establishes connection and updates player connectivity', () async {
      when(
        () => matchRepository.setHostConnectivity(
          match: matchId,
          active: any<bool>(named: 'active'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => matchRepository.getPlayerConnectivity(
          matchId: matchId,
          isHost: true,
        ),
      ).thenAnswer((_) async => false);

      final socket = await startSocket();

      await untilCalled(
        () => matchRepository.setHostConnectivity(match: matchId, active: true),
      );
      verify(
        () => matchRepository.setHostConnectivity(match: matchId, active: true),
      ).called(1);

      await expectLater(
        socket.messages,
        emits(
          jsonEncode(
            const WebSocketMessage(message: MessageType.connected).toJson(),
          ),
        ),
      );

      socket.close();

      await untilCalled(
        () =>
            matchRepository.setHostConnectivity(match: matchId, active: false),
      );
      verify(
        () =>
            matchRepository.setHostConnectivity(match: matchId, active: false),
      ).called(1);
    });

    test('throws when player is already connected', () async {
      when(
        () => matchRepository.setHostConnectivity(
          match: matchId,
          active: any<bool>(named: 'active'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => matchRepository.getPlayerConnectivity(
          matchId: matchId,
          isHost: true,
        ),
      ).thenAnswer((_) async => true);

      final socket = await startSocket();

      await untilCalled(
        () => matchRepository.getPlayerConnectivity(
          matchId: matchId,
          isHost: true,
        ),
      );
      verify(
        () => matchRepository.getPlayerConnectivity(
          matchId: matchId,
          isHost: true,
        ),
      ).called(1);

      // socket.messages.listen(print);

      final message = await socket.messages.first;
      // print(message);

      // await expectLater(
      //   socket.messages,
      //   emits(
      //     jsonEncode(
      //       const WebSocketMessage(error: ErrorType.playerAlreadyConnected)
      //           .toJson(),
      //     ),
      //   ),
      // );
      // await socket.connection.firstWhere((state) => state is Connected);
      // final message = await socket.messages.firstWhere(
      //   (message) {
      //     print(message);
      //     return true;
      //   },
      // );

      expect(
        message,
        equals(
          jsonEncode(
            const WebSocketMessage(error: ErrorType.playerAlreadyConnected)
                .toJson(),
          ),
        ),
      );

      socket.close();

      // verifyNever(
      //   () =>
      //     matchRepository.setHostConnectivity(match: matchId, active: false),
      // );
    });

    test('throws when cannot update player connectivity', () async {
      when(
        () => matchRepository.setHostConnectivity(
          match: matchId,
          active: any<bool>(named: 'active'),
        ),
      ).thenThrow(Exception('oops'));
      when(
        () => matchRepository.getPlayerConnectivity(
          matchId: matchId,
          isHost: true,
        ),
      ).thenAnswer((_) async => false);

      final socket = await startSocket();

      await untilCalled(
        () => matchRepository.setHostConnectivity(match: matchId, active: true),
      );
      verify(
        () => matchRepository.setHostConnectivity(match: matchId, active: true),
      ).called(1);

      await expectLater(
        socket.messages,
        emits(
          jsonEncode(
            const WebSocketMessage(
              error: ErrorType.firebaseException,
            ).toJson(),
          ),
        ),
      );

      socket.close();
    });
  });
}
