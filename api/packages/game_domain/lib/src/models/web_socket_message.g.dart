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
  MessageType.disconnected: 'disconnected',
  MessageType.error: 'error',
  MessageType.token: 'token',
};

WebSocketTokenPayload _$WebSocketTokenPayloadFromJson(
        Map<String, dynamic> json) =>
    WebSocketTokenPayload(
      token: json['token'] as String,
    );

Map<String, dynamic> _$WebSocketTokenPayloadToJson(
        WebSocketTokenPayload instance) =>
    <String, dynamic>{
      'token': instance.token,
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
};
