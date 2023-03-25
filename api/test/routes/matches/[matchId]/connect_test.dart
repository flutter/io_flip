import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../../../routes/matches/[matchId]/connect.dart' as route;

class _MockMatchRepository extends Mock implements MatchRepository {}

void main() {
  late HttpServer server;
  late MatchRepository matchRepository;

  const matchId = 'matchId';
  const newMatch = Match(
    id: matchId,
    hostDeck: Deck(cards: [], id: '', userId: ''),
    guestDeck: Deck(cards: [], id: '', userId: ''),
  );
  const connectedMatch = Match(
    id: matchId,
    hostDeck: Deck(cards: [], id: '', userId: ''),
    guestDeck: Deck(cards: [], id: '', userId: ''),
    hostConnected: true,
  );

  Future<WebSocket> startSocket() async {
    server = await serve(
      (context) => route.onRequest(
        context.provide<MatchRepository>(() => matchRepository),
        matchId,
      ),
      InternetAddress.anyIPv4,
      0,
    );
    final socket = WebSocket(
      Uri.parse('ws://localhost:${server.port}?host=true'),
    );
    return socket;
  }

  group('GET /matches/[matchId]/connect', () {
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
        () => matchRepository.getMatch(matchId),
      ).thenAnswer(
        (_) async => newMatch,
      );

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
        () => matchRepository.getMatch(matchId),
      ).thenAnswer(
        (_) async => connectedMatch,
      );

      final socket = await startSocket();

      await expectLater(
        socket.messages,
        emits(
          jsonEncode(
            const WebSocketMessage(error: ErrorType.playerAlreadyConnected)
                .toJson(),
          ),
        ),
      );

      socket.close();

      verifyNever(
        () =>
            matchRepository.setHostConnectivity(match: matchId, active: false),
      );
    });

    test('throws when cannot update player connectivity', () async {
      when(
        () => matchRepository.setHostConnectivity(
          match: matchId,
          active: any<bool>(named: 'active'),
        ),
      ).thenThrow(Exception('oops'));
      when(
        () => matchRepository.getMatch(matchId),
      ).thenAnswer(
        (_) async => newMatch,
      );

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
