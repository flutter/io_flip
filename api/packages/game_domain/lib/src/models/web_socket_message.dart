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

  /// Represents a connection error.
  error,

  /// Represents an authentication token being sent.
  token,

  /// Represents a match being joined.
  matchJoined,

  /// Represents a match being left.
  matchLeft,
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
  WebSocketMessage.token(String token, {bool reconnect = false})
      : this(
          messageType: MessageType.token,
          payload: WebSocketTokenPayload(token: token, reconnect: reconnect),
        );

  /// A message indicating a match has been joined.
  WebSocketMessage.matchJoined({required String matchId, required bool isHost})
      : this(
          messageType: MessageType.matchJoined,
          payload: WebSocketMatchJoinedPayload(
            matchId: matchId,
            isHost: isHost,
          ),
        );

  /// A message indicating a match has been left.
  const WebSocketMessage.matchLeft() : this(messageType: MessageType.matchLeft);

  /// A message indicating the socket has connected.
  const WebSocketMessage.connected() : this(messageType: MessageType.connected);

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
        case MessageType.matchJoined:
          messagePayload = WebSocketMatchJoinedPayload.fromJson(payloadJson);
          break;
        case MessageType.connected:
        case MessageType.matchLeft:
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
    required this.reconnect,
  });

  /// Deserializes a [WebSocketTokenPayload] from a json map.
  factory WebSocketTokenPayload.fromJson(Map<String, dynamic> json) =>
      _$WebSocketTokenPayloadFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WebSocketTokenPayloadToJson(this);

  /// The user's id token.
  @JsonKey()
  final String token;

  /// Whether or not the user is reconnecting.
  @JsonKey()
  final bool reconnect;

  @override
  List<Object?> get props => [token, reconnect];
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

/// {@template web_socket_match_joined_payload}
/// The payload for a match joined message.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class WebSocketMatchJoinedPayload extends WebSocketMessagePayload {
  /// {@macro web_socket_match_joined_payload}
  const WebSocketMatchJoinedPayload({
    required this.matchId,
    required this.isHost,
  });

  /// Deserializes a [WebSocketMatchJoinedPayload] from a json map.
  factory WebSocketMatchJoinedPayload.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMatchJoinedPayloadFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WebSocketMatchJoinedPayloadToJson(this);

  /// The id of the match that was joined.
  @JsonKey()
  final String matchId;

  /// Whether or not the player is the host of the match.
  @JsonKey()
  final bool isHost;

  @override
  List<Object?> get props => [matchId, isHost];
}
