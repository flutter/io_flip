// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) =>
    WebSocketMessage(
      message: json['message'] as String,
      error: $enumDecodeNullable(_$ErrorTypeEnumMap, json['error']),
    );

Map<String, dynamic> _$WebSocketMessageToJson(WebSocketMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'error': _$ErrorTypeEnumMap[instance.error],
    };

const _$ErrorTypeEnumMap = {
  ErrorType.badRequest: 'badRequest',
  ErrorType.firebaseException: 'firebaseException',
};
