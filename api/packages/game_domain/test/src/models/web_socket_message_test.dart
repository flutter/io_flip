// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('WebSocketMessage', () {
    test('can be instantiated', () {
      expect(
        WebSocketMessage(),
        isNotNull,
      );
    });

    final message = WebSocketMessage(
      message: MessageType.connected,
      error: ErrorType.firebaseException,
    );

    test('fromJson returns the correct instance', () {
      expect(
        WebSocketMessage.fromJson(const {
          'message': 'connected',
          'error': 'firebaseException',
        }),
        equals(message),
      );
    });

    test('toJson returns the correct instance', () {
      expect(
        message.toJson(),
        equals(const {
          'message': 'connected',
          'error': 'firebaseException',
        }),
      );
    });

    test('supports equality', () {
      expect(
        message,
        equals(
          WebSocketMessage(
            message: MessageType.connected,
            error: ErrorType.firebaseException,
          ),
        ),
      );

      expect(
        WebSocketMessage(
          message: MessageType.connected,
        ),
        isNot(
          equals(message),
        ),
      );
      expect(
        WebSocketMessage(error: ErrorType.firebaseException),
        isNot(
          equals(message),
        ),
      );
    });
  });
}
