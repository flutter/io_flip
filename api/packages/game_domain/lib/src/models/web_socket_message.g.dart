// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) =>
    WebSocketMessage(
      message: $enumDecodeNullable(_$MessageTypeEnumMap, json['message']),
      error: $enumDecodeNullable(_$ErrorTypeEnumMap, json['error']),
    );

Map<String, dynamic> _$WebSocketMessageToJson(WebSocketMessage instance) =>
    <String, dynamic>{
      'message': _$MessageTypeEnumMap[instance.message],
      'error': _$ErrorTypeEnumMap[instance.error],
    };

const _$MessageTypeEnumMap = {
  MessageType.connected: 'connected',
  MessageType.disconnected: 'disconnected',
};

const _$ErrorTypeEnumMap = {
  ErrorType.badRequest: 'badRequest',
  ErrorType.firebaseException: 'firebaseException',
  ErrorType.playerAlreadyConnected: 'playerAlreadyConnected',
  ErrorType.playerNotConnectedToGame: 'playerNotConnectedToGame',
};
