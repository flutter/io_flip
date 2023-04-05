import 'dart:async';
import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockWebSocket extends Mock implements WebSocket {}

void main() {
  late ApiClient apiClient;
  late WebSocket webSocket;
  late StreamController<dynamic> webSocketMessages;
  late ConnectionRepository subject;

  setUp(() {
    apiClient = _MockApiClient();
    webSocket = _MockWebSocket();
    webSocketMessages = StreamController<dynamic>();

    when(() => apiClient.connect(any())).thenAnswer((_) async => webSocket);
    when(() => webSocket.messages).thenAnswer((_) => webSocketMessages.stream);
    when(webSocket.close).thenAnswer((_) async {});
    when(() => webSocket.send(any<String>())).thenAnswer((_) async {});

    subject = ConnectionRepository(apiClient: apiClient);
  });

  group('ConnectionRepository', () {
    group('connect', () {
      test('calls connect on api client with correct path', () async {
        await subject.connect();

        verify(() => apiClient.connect('/public/connect')).called(1);
      });
    });

    group('messages', () {
      test('emits all WebSocketMessages and ignores other messages', () async {
        await subject.connect();

        webSocketMessages
          ..add(jsonEncode(const WebSocketMessage.connected()))
          ..add('not a WebSocketMessage')
          ..add(jsonEncode(const WebSocketMessage.disconnected()))
          ..add(jsonEncode({'not': 'a WebSocketMessage'}));

        await expectLater(
          subject.messages,
          emitsInOrder([
            const WebSocketMessage.connected(),
            const WebSocketMessage.disconnected(),
          ]),
        );
      });
    });

    group('send', () {
      test('calls send on web socket with correct message', () async {
        await subject.connect();

        subject.send(const WebSocketMessage.connected());

        verify(
          () => webSocket.send(jsonEncode(const WebSocketMessage.connected())),
        ).called(1);
      });
    });

    group('close', () {
      test('calls close on web socket', () async {
        await subject.connect();

        subject.close();

        verify(() => webSocket.close()).called(1);
      });
    });
  });
}
