import 'dart:async';
import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:web_socket_client/web_socket_client.dart';

/// {@template connection_repository}
/// Repository to manage the connection state.
/// {@endtemplate}
class ConnectionRepository {
  /// {@macro connection_repository}
  ConnectionRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  WebSocket? _webSocket;

  /// Connects to the server using a WebSocket.
  Future<void> connect() async {
    _webSocket = await _apiClient.connect('/public/connect');
  }

  /// The stream of [WebSocketMessage] received from the server.
  Stream<WebSocketMessage> get messages =>
      _webSocket?.messages.transform(
        StreamTransformer.fromHandlers(
          handleData: (rawMessage, sink) {
            try {
              if (rawMessage is String) {
                final messageJson = jsonDecode(rawMessage);
                if (messageJson is Map) {
                  final message = WebSocketMessage.fromJson(
                    Map<String, dynamic>.from(messageJson),
                  );

                  sink.add(message);
                }
              }
            } catch (e) {
              // ignore it
            }
          },
        ),
      ) ??
      const Stream.empty();

  /// Sends a [WebSocketMessage] to the server.
  void send(WebSocketMessage message) {
    _webSocket?.send(jsonEncode(message));
  }

  /// Closes the connection to the server.
  void close() {
    _webSocket?.close();
    _webSocket = null;
  }
}
