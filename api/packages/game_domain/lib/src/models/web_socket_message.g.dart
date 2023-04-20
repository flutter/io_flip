// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$WebSocketMessageToJson(WebSocketMessage instance) =>
    <String, dynamic>{
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'payload': instance.payload,
    };

const _$MessageTypeEnumMap = {
  MessageType.connected: 'connected',
  MessageType.error: 'error',
  MessageType.token: 'token',
  MessageType.matchJoined: 'matchJoined',
  MessageType.matchLeft: 'matchLeft',
};

WebSocketTokenPayload _$WebSocketTokenPayloadFromJson(
        Map<String, dynamic> json) =>
    WebSocketTokenPayload(
      token: json['token'] as String,
      reconnect: json['reconnect'] as bool,
    );

Map<String, dynamic> _$WebSocketTokenPayloadToJson(
        WebSocketTokenPayload instance) =>
    <String, dynamic>{
      'token': instance.token,
      'reconnect': instance.reconnect,
    };

WebSocketErrorPayload _$WebSocketErrorPayloadFromJson(
        Map<String, dynamic> json) =>
    WebSocketErrorPayload(
      errorCode: $enumDecode(_$WebSocketErrorCodeEnumMap, json['errorCode']),
    );

Map<String, dynamic> _$WebSocketErrorPayloadToJson(
        WebSocketErrorPayload instance) =>
    <String, dynamic>{
      'errorCode': _$WebSocketErrorCodeEnumMap[instance.errorCode]!,
    };

const _$WebSocketErrorCodeEnumMap = {
  WebSocketErrorCode.badRequest: 'badRequest',
  WebSocketErrorCode.firebaseException: 'firebaseException',
  WebSocketErrorCode.playerAlreadyConnected: 'playerAlreadyConnected',
  WebSocketErrorCode.unknown: 'unknown',
};

WebSocketMatchJoinedPayload _$WebSocketMatchJoinedPayloadFromJson(
        Map<String, dynamic> json) =>
    WebSocketMatchJoinedPayload(
      matchId: json['matchId'] as String,
      isHost: json['isHost'] as bool,
    );

Map<String, dynamic> _$WebSocketMatchJoinedPayloadToJson(
        WebSocketMatchJoinedPayload instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'isHost': instance.isHost,
    };
