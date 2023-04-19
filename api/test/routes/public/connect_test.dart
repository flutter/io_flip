// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:game_domain/game_domain.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:match_repository/match_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../main.dart';
import '../../../routes/public/connect.dart';
import '../../../routes/public/connect.dart' as route show onRequest;

typedef _OnConnection = void Function(
  WebSocketChannel channel,
  String? protocol,
);

class _MockMatchRepository extends Mock implements MatchRepository {}

class _MockJwtMiddleware extends Mock implements JwtMiddleware {}

class _MockWebSocketSink extends Mock implements WebSocketSink {}

class _FakeRequestContext extends Fake implements RequestContext {
  _FakeRequestContext({
    required this.getRequest,
    required this.matchRepository,
    required this.webSocketHandlerFactory,
  });

  final Request Function() getRequest;

  @override
  Request get request => getRequest();

  final MatchRepository matchRepository;
  final WebSocketHandlerFactory webSocketHandlerFactory;

  @override
  T read<T>() {
    if (T == MatchRepository) {
      return matchRepository as T;
    }
    if (T == WebSocketHandlerFactory) {
      return webSocketHandlerFactory as T;
    }

    throw UnimplementedError();
  }
}

class _FakeRequest extends Fake implements Request {
  _FakeRequest({
    required this.uri,
  });

  @override
  final Uri uri;
}

class _FakeResponse extends Fake implements Response {}

class _FakeWebSocketChannel extends Fake implements WebSocketChannel {
  _FakeWebSocketChannel({
    required this.stream,
    required this.sink,
  });

  @override
  final Stream<dynamic> stream;

  @override
  final WebSocketSink sink;
}

class _FakeWebSocketHandlerFactory extends Fake {
  _FakeWebSocketHandlerFactory({
    required this.channelStream,
    required this.channelSink,
    required this.onCreate,
  });
  final Stream<dynamic> channelStream;
  final WebSocketSink channelSink;
  final void Function(
    _OnConnection onConnection,
  ) onCreate;

  Handler call(
    _OnConnection onConnection,
  ) {
    return (context) async {
      onCreate(onConnection);
      return _FakeResponse();
    };
  }
}

void main() {
  group('GET /connect', () {
    late MatchRepository matchRepository;
    late StreamController<dynamic> channelStream;
    late WebSocketSink channelSink;
    late RequestContext context;
    late _OnConnection onConnection;

    const matchId = 'matchId';
    const userId = 'userId';

    setUp(() {
      channelStream = StreamController<dynamic>();
      channelSink = _MockWebSocketSink();

      jwtMiddleware = _MockJwtMiddleware();
      when(
        () => jwtMiddleware.verifyToken(any()),
      ).thenAnswer((_) async => userId);

      matchRepository = _MockMatchRepository();
      when(
        () => matchRepository.setPlayerConnectivity(
          userId: any(named: 'userId'),
          connected: any<bool>(named: 'connected'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => matchRepository.setHostConnectivity(
          match: matchId,
          active: any<bool>(named: 'active'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => matchRepository.setGuestConnectivity(
          match: matchId,
          active: any<bool>(named: 'active'),
        ),
      ).thenAnswer((_) async {});

      context = _FakeRequestContext(
        getRequest: () => _FakeRequest(
          uri: Uri(path: '/public/connect'),
        ),
        matchRepository: matchRepository,
        webSocketHandlerFactory: _FakeWebSocketHandlerFactory(
          channelStream: channelStream.stream,
          channelSink: channelSink,
          onCreate: (newOnConnection) {
            onConnection = newOnConnection;
          },
        ).call,
      );
    });

    tearDown(() {
      channelStream.close();
    });

    void connectToSocket() {
      onConnection(
        _FakeWebSocketChannel(
          stream: channelStream.stream,
          sink: channelSink,
        ),
        null,
      );
    }

    Future<void> waitAndVerify(void Function() action) async {
      await untilCalled(action);
      verify(action).called(1);
    }

    Future<void> checkSetHostConnectivity({required bool active}) =>
        waitAndVerify(
          () => matchRepository.setHostConnectivity(
            match: matchId,
            active: active,
          ),
        );

    Future<void> checkSetGuestConnectivity({required bool active}) =>
        waitAndVerify(
          () => matchRepository.setGuestConnectivity(
            match: matchId,
            active: active,
          ),
        );

    Future<void> checkSetPlayerConnectivity({required bool connected}) =>
        waitAndVerify(
          () => matchRepository.setPlayerConnectivity(
            userId: userId,
            connected: connected,
          ),
        );

    Future<void> checkResponseSent(String message) =>
        waitAndVerify(() => channelSink.add(message));

    test('does nothing when no token message is sent', () async {
      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();
      await channelStream.close();

      verifyZeroInteractions(matchRepository);
    });

    test('does nothing when authentication fails', () async {
      when(() => jwtMiddleware.verifyToken('token'))
          .thenAnswer((_) async => null);

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();

      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await channelStream.close();

      verifyZeroInteractions(matchRepository);
    });

    test('establishes user connection', () async {
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) async => false);

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();

      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await checkSetPlayerConnectivity(connected: true);
      await checkResponseSent(jsonEncode(const WebSocketMessage.connected()));

      await channelStream.close();

      await checkSetPlayerConnectivity(connected: false);
    });

    test('on matchJoined updates host connectivity', () async {
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) async => false);

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();

      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await checkSetPlayerConnectivity(connected: true);

      channelStream.add(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: true,
          ),
        ),
      );

      await checkSetHostConnectivity(active: true);
      await checkResponseSent(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: true,
          ),
        ),
      );

      await channelStream.close();

      await checkSetPlayerConnectivity(connected: false);
      await checkSetHostConnectivity(active: false);
    });

    test('on matchJoined updates old match connectivity', () async {
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) async => false);

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();

      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await checkSetPlayerConnectivity(connected: true);

      channelStream.add(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: true,
          ),
        ),
      );

      await checkSetHostConnectivity(active: true);
      await checkResponseSent(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: true,
          ),
        ),
      );

      channelStream.add(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: false,
          ),
        ),
      );
      await checkSetHostConnectivity(active: false);
      await checkSetGuestConnectivity(active: true);
      await checkResponseSent(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: false,
          ),
        ),
      );

      await channelStream.close();

      await checkSetPlayerConnectivity(connected: false);
      await checkSetGuestConnectivity(active: false);
    });

    test('on matchJoined updates guest connectivity', () async {
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) async => false);

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();

      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await checkSetPlayerConnectivity(connected: true);

      channelStream.add(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: false,
          ),
        ),
      );

      await checkSetGuestConnectivity(active: true);
      await checkResponseSent(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: false,
          ),
        ),
      );

      await channelStream.close();

      await checkSetPlayerConnectivity(connected: false);
      await checkSetGuestConnectivity(active: false);
    });

    test('on matchLeft updates connectivity', () async {
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) async => false);

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();

      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await checkSetPlayerConnectivity(connected: true);

      channelStream.add(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: false,
          ),
        ),
      );

      await checkSetGuestConnectivity(active: true);
      await checkResponseSent(
        jsonEncode(
          WebSocketMessage.matchJoined(
            matchId: matchId,
            isHost: false,
          ),
        ),
      );

      channelStream.add(jsonEncode(const WebSocketMessage.matchLeft()));
      await checkSetGuestConnectivity(active: false);

      await channelStream.close();

      await checkSetPlayerConnectivity(connected: false);
    });

    test('sets old user as inactive when a new user connects', () async {
      when(() => jwtMiddleware.verifyToken('token2'))
          .thenAnswer((_) async => 'newUserId');
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) async => false);
      when(
        () => matchRepository.getPlayerConnectivity(userId: 'newUserId'),
      ).thenAnswer((_) async => false);

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();
      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await checkSetPlayerConnectivity(connected: true);

      channelStream.add(jsonEncode(WebSocketMessage.token('token2')));

      await checkSetPlayerConnectivity(connected: false);
      await waitAndVerify(
        () => matchRepository.setPlayerConnectivity(
          userId: 'newUserId',
          connected: true,
        ),
      );
    });

    test('sends error when player is already connected', () async {
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) async => true);

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();

      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await waitAndVerify(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      );
      await checkResponseSent(
        jsonEncode(
          WebSocketMessage.error(
            WebSocketErrorCode.playerAlreadyConnected,
          ),
        ),
      );
    });

    test(
      'sends connected when player is already connected but reconnect is true',
      () async {
        when(
          () => matchRepository.getPlayerConnectivity(userId: userId),
        ).thenAnswer((_) async => true);

        final response = await route.onRequest(context);
        expect(response, isA<_FakeResponse>());

        connectToSocket();

        channelStream.add(
          jsonEncode(
            WebSocketMessage.token(
              'token',
              reconnect: true,
            ),
          ),
        );

        await waitAndVerify(
          () => matchRepository.getPlayerConnectivity(userId: userId),
        );
        await checkResponseSent(jsonEncode(const WebSocketMessage.connected()));
      },
    );

    test('sends error when cannot update player connectivity', () async {
      when(
        () => matchRepository.getPlayerConnectivity(userId: userId),
      ).thenAnswer((_) async => false);
      when(
        () => matchRepository.setPlayerConnectivity(
          userId: userId,
          connected: true,
        ),
      ).thenThrow(Exception('oops'));

      final response = await route.onRequest(context);
      expect(response, isA<_FakeResponse>());

      connectToSocket();

      channelStream.add(jsonEncode(WebSocketMessage.token('token')));

      await checkSetPlayerConnectivity(connected: true);

      await checkResponseSent(
        jsonEncode(
          WebSocketMessage.error(WebSocketErrorCode.firebaseException),
        ),
      );

      await channelStream.close();

      await checkSetPlayerConnectivity(connected: false);
    });
  });
}
