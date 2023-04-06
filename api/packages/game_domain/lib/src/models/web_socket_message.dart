import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'web_socket_message.g.dart';

/// Represents the type of error passed from the websocket.
enum WebSocketErrorCode {
  /// Represents missing query parameters.
  badRequest,

  /// Represents an Exception thrown by Firebase.
  firebaseException,

  /// Represents a player that is already connect to the socket.
  playerAlreadyConnected,

  /// Represents an unknown error.
  unknown,
}

/// Represents the message passed from the websocket.
enum MessageType {
  /// Represents a successful connection.
  connected,

  /// Represents a disconnect from the socket.
  disconnected,

  /// Represents a connection error.
  error,

  /// Represents an authentication token being sent.
  token,
}

/// {@template web_socket_message}
/// Message sent or received over a websocket.
/// {@endtemplate}
@JsonSerializable(createFactory: false, ignoreUnannotated: true)
class WebSocketMessage extends Equatable {
  /// {@macro web_socket_message}
  const WebSocketMessage({required this.messageType, this.payload});

  /// A message representing an error.
  WebSocketMessage.error(WebSocketErrorCode error)
      : this(
          messageType: MessageType.error,
          payload: WebSocketErrorPayload(errorCode: error),
        );

  /// A message containing an authentication token.
  WebSocketMessage.token(String token)
      : this(
          messageType: MessageType.token,
          payload: WebSocketTokenPayload(token: token),
        );

  /// A message indicating the socket has connected.
  const WebSocketMessage.connected() : this(messageType: MessageType.connected);

  /// A message indicating the socket has disconnected.
  const WebSocketMessage.disconnected()
      : this(messageType: MessageType.disconnected);

  /// {@macro web_socket_message}
  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    final messageType = $enumDecode(_$MessageTypeEnumMap, json['messageType']);
    final payload = json['payload'] as Map?;
    WebSocketMessagePayload? messagePayload;
    if (payload != null) {
      final payloadJson = Map<String, dynamic>.from(payload);
      switch (messageType) {
        case MessageType.error:
          messagePayload = WebSocketErrorPayload.fromJson(payloadJson);
          break;
        case MessageType.token:
          messagePayload = WebSocketTokenPayload.fromJson(payloadJson);
          break;
        case MessageType.connected:
        case MessageType.disconnected:
          break;
      }
    }
    return WebSocketMessage(
      messageType: messageType,
      payload: messagePayload,
    );
  }

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$WebSocketMessageToJson(this);

  /// The [MessageType] of the message.
  @JsonKey()
  final MessageType messageType;

  /// The payload of the message.
  @JsonKey()
  final WebSocketMessagePayload? payload;

  @override
  List<Object?> get props => [messageType, payload];
}

/// {@template web_socket_message_payload}
/// A payload sent or received as part of a [WebSocketMessage].
/// {@endtemplate}
abstract class WebSocketMessagePayload extends Equatable {
  /// {@macro web_socket_message_payload}
  const WebSocketMessagePayload();

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson();
}

/// {@template web_socket_token_payload}
/// The payload for a token message.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class WebSocketTokenPayload extends WebSocketMessagePayload {
  /// {@macro web_socket_token_payload}
  const WebSocketTokenPayload({
    required this.token,
  });

  /// Deserializes a [WebSocketTokenPayload] from a json map.
  factory WebSocketTokenPayload.fromJson(Map<String, dynamic> json) =>
      _$WebSocketTokenPayloadFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WebSocketTokenPayloadToJson(this);

  /// The user's id token.
  @JsonKey()
  final String token;

  @override
  List<Object?> get props => [token];
}

/// {@template web_socket_error_payload}
/// The payload for an error message.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class WebSocketErrorPayload extends WebSocketMessagePayload {
  /// {@macro web_socket_error_payload}
  const WebSocketErrorPayload({
    required this.errorCode,
  });

  /// Deserializes a [WebSocketErrorPayload] from a json map.
  factory WebSocketErrorPayload.fromJson(Map<String, dynamic> json) =>
      _$WebSocketErrorPayloadFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WebSocketErrorPayloadToJson(this);

  /// The error code of the error.
  @JsonKey()
  final WebSocketErrorCode errorCode;

  @override
  List<Object?> get props => [errorCode];
}
