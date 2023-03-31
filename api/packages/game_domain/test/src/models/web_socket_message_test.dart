// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('WebSocketMessage', () {
    group('error', () {
      test('has correct message type', () {
        final message = WebSocketMessage.error(WebSocketErrorCode.badRequest);

        expect(message.messageType, equals(MessageType.error));
      });

      test('has correct payload', () {
        final message = WebSocketMessage.error(WebSocketErrorCode.badRequest);

        expect(
          message.payload,
          isA<WebSocketErrorPayload>().having(
            (p) => p.errorCode,
            'errorCode',
            WebSocketErrorCode.badRequest,
          ),
        );
      });

      test('uses value equality', () {
        final a = WebSocketMessage.error(WebSocketErrorCode.badRequest);
        final b = WebSocketMessage.error(WebSocketErrorCode.badRequest);
        final c = WebSocketMessage.error(
          WebSocketErrorCode.playerAlreadyConnected,
        );

        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });

      group('json', () {
        final json = {
          'messageType': 'error',
          'payload': {'errorCode': 'badRequest'},
        };

        final message = WebSocketMessage.error(WebSocketErrorCode.badRequest);

        test('fromJson deserializes correctly', () {
          expect(WebSocketMessage.fromJson(json), equals(message));
        });

        test('toJson serializes correctly', () {
          expect(jsonEncode(message), equals(jsonEncode(json)));
        });
      });
    });

    group('token', () {
      test('has correct message type', () {
        final message = WebSocketMessage.token('token');

        expect(message.messageType, equals(MessageType.token));
      });

      test('has correct payload', () {
        final message = WebSocketMessage.token('token');

        expect(
          message.payload,
          isA<WebSocketTokenPayload>().having(
            (p) => p.token,
            'token',
            'token',
          ),
        );
      });

      test('uses value equality', () {
        final a = WebSocketMessage.token('token');
        final b = WebSocketMessage.token('token');
        final c = WebSocketMessage.token('other');

        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });

      group('json', () {
        final json = {
          'messageType': 'token',
          'payload': {'token': 'abcd'},
        };

        final message = WebSocketMessage.token('abcd');

        test('fromJson deserializes correctly', () {
          expect(WebSocketMessage.fromJson(json), equals(message));
        });

        test('toJson serializes correctly', () {
          expect(jsonEncode(message), equals(jsonEncode(json)));
        });
      });
    });

    group('connected', () {
      test('has correct message type', () {
        final message = WebSocketMessage.connected();

        expect(message.messageType, equals(MessageType.connected));
      });

      test('has no payload', () {
        final message = WebSocketMessage.connected();

        expect(message.payload, isNull);
      });

      test('uses value equality', () {
        final a = WebSocketMessage.connected();
        final b = WebSocketMessage.connected();

        expect(a, equals(b));
      });

      group('json', () {
        final json = {
          'messageType': 'connected',
          'payload': null,
        };

        final message = WebSocketMessage.connected();

        test('fromJson deserializes correctly', () {
          expect(WebSocketMessage.fromJson(json), equals(message));
        });

        test('fromJson deserializes correctly with payload', () {
          expect(
            WebSocketMessage.fromJson({
              ...json,
              'payload': const {'a': 'b'}
            }),
            equals(message),
          );
        });

        test('toJson serializes correctly', () {
          expect(jsonEncode(message), equals(jsonEncode(json)));
        });
      });
    });

    group('disconnected', () {
      test('has correct message type', () {
        final message = WebSocketMessage.disconnected();

        expect(message.messageType, equals(MessageType.disconnected));
      });

      test('has no payload', () {
        final message = WebSocketMessage.disconnected();

        expect(message.payload, isNull);
      });

      test('uses value equality', () {
        final a = WebSocketMessage.disconnected();
        final b = WebSocketMessage.disconnected();

        expect(a, equals(b));
      });

      group('json', () {
        final json = {
          'messageType': 'disconnected',
          'payload': null,
        };

        final message = WebSocketMessage.disconnected();

        test('fromJson deserializes correctly', () {
          expect(WebSocketMessage.fromJson(json), equals(message));
        });

        test('fromJson deserializes correctly with payload', () {
          expect(
            WebSocketMessage.fromJson({
              ...json,
              'payload': const {'a': 'b'}
            }),
            equals(message),
          );
        });

        test('toJson serializes correctly', () {
          expect(jsonEncode(message), equals(jsonEncode(json)));
        });
      });
    });
  });
}
