import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'web_socket_message.g.dart';

/// Represents the type of error passed from the websocket.
enum ErrorType {
  /// Represents missing query parameters.
  badRequest,

  /// Represents an Exception thrown by Firebase.
  firebaseException,

  /// Represents a player that is already connect to the socket.
  playerAlreadyConnected,
}

/// Represents the message passed from the websocket.
enum MessageType {
  /// Represents a successful connection.
  connected,

  /// Represents a disconnect from the socket.
  disconnected,
}

/// {@template web_socket_message}
/// Message response from websocket.
/// {@endtemplate}
@JsonSerializable(ignoreUnannotated: true)
class WebSocketMessage extends Equatable {
  /// {@macro web_socket_message}
  const WebSocketMessage({this.message, this.error});

  /// {@macro web_socket_message}
  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);

  /// Message
  @JsonKey()
  final MessageType? message;

  /// Error
  @JsonKey()
  final ErrorType? error;

  /// Returns a json representation from this instance.
  Map<String, dynamic> toJson() => _$WebSocketMessageToJson(this);

  @override
  List<Object?> get props => [message, error];
}
